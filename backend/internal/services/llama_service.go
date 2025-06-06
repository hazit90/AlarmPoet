package services

import (
	"context"
	"fmt"
	"log"
	"strings"

	"github.com/sashabaranov/go-openai"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
)

// Package services contains the business logic for the AlarmPoet application.
// This file implements the poem generation logic using LLaMA 3.

func getAPIKeyFromK8sSecret() (string, error) {
	log.Println("getAPIKeyFromK8sSecret: Starting to fetch API key from Kubernetes secret")

	config, err := rest.InClusterConfig()
	if err != nil {
		log.Printf("getAPIKeyFromK8sSecret: Failed to create in-cluster config: %v", err)
		return "", fmt.Errorf("failed to create in-cluster config: %v", err)
	}

	log.Println("getAPIKeyFromK8sSecret: Successfully created in-cluster config")

	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		log.Printf("getAPIKeyFromK8sSecret: Failed to create Kubernetes client: %v", err)
		return "", fmt.Errorf("failed to create Kubernetes client: %v", err)
	}

	log.Println("getAPIKeyFromK8sSecret: Successfully created Kubernetes client")

	secret, err := clientset.CoreV1().Secrets("default").Get(context.Background(), "openai-api-key", metav1.GetOptions{})
	if err != nil {
		log.Printf("getAPIKeyFromK8sSecret: Failed to fetch secret: %v", err)
		return "", fmt.Errorf("failed to fetch secret: %v", err)
	}

	log.Println("getAPIKeyFromK8sSecret: Successfully fetched secret")

	apiKey, exists := secret.Data["api-key"]
	if !exists {
		log.Println("getAPIKeyFromK8sSecret: api-key not found in secret")
		return "", fmt.Errorf("api-key not found in secret")
	}

	log.Println("getAPIKeyFromK8sSecret: Successfully retrieved API key")
	return string(apiKey), nil
}

// GeneratePoem generates a poem based on the provided keywords.
// It returns a string containing the generated poem.
func GeneratePoem(keywords []string) string {
	log.Printf("GeneratePoem: Generating poem for keywords: %v", keywords)

	apiKey, err := getAPIKeyFromK8sSecret()
	if err != nil {
		log.Printf("GeneratePoem: Failed to get API key: %v", err)
		return "Failed to generate poem: Unable to access API key"
	}
	client := openai.NewClient(apiKey)
	prompt := fmt.Sprintf("Write a poem inspired by the following keywords: %s", strings.Join(keywords, ", "))

	req := openai.ChatCompletionRequest{
		Model: openai.GPT4oMini,
		Messages: []openai.ChatCompletionMessage{
			{
				Role:    openai.ChatMessageRoleSystem,
				Content: "You are a helpful assistant that writes creative poems.",
			},
			{
				Role:    openai.ChatMessageRoleUser,
				Content: prompt,
			},
		},
		MaxTokens: 150,
	}

	resp, err := client.CreateChatCompletion(context.Background(), req)
	if err != nil {
		return fmt.Sprintf("Failed to generate poem: %v", err)
	}

	poem := resp.Choices[0].Message.Content
	log.Printf("GeneratePoem: Generated poem: %s", poem)

	return poem
}
