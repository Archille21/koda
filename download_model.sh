#!/bin/bash
# download_model.sh — Downloads the Koda model weights (Qwen2.5-Coder-7B-Instruct, GGUF Q4_K_M)
# Required by the ADTC 2026 submission template. Must be idempotent and work without credentials.

set -e  # Exit immediately if any command fails

# Directory and file names for the model weights
MODEL_DIR="model"
MODEL_FILE="qwen2.5-coder-7b-instruct-q4_k_m.gguf"
MODEL_PATH="${MODEL_DIR}/${MODEL_FILE}"

# Public Hugging Face URL — no authentication required
MODEL_URL="https://huggingface.co/Qwen/Qwen2.5-Coder-7B-Instruct-GGUF/resolve/main/${MODEL_FILE}?download=true"

# Create the model directory if it doesn't exist yet
mkdir -p "$MODEL_DIR"

# Idempotency check: skip download if the model is already present
if [ -f "$MODEL_PATH" ]; then
    echo "Model already exists at $MODEL_PATH — skipping download."
    exit 0
fi

# Download the model weights
echo "Downloading Qwen2.5-Coder-7B-Instruct (Q4_K_M) from Hugging Face..."
curl -L -o "$MODEL_PATH" "$MODEL_URL"

echo "Download complete: $MODEL_PATH"
