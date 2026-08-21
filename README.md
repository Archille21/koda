# Koda

**Learning to code shouldn't depend on internet access.**

Koda is a 100% offline AI tutor built for African students learning to code — running entirely on modest, budget laptops, without any internet connection or human mentor required.

Built for the [Africa Deep Tech Challenge 2026](https://adtc-2026.devpost.com) — Laptop LLM track (`coding_assistants` domain).

---

## 🎯 The Problem

Millions of aspiring programmers across Africa have access to an old laptop but not to reliable, affordable internet. Existing AI coding tutors assume constant cloud connectivity — Koda doesn't.

## 💡 What Koda Does

Koda runs a quantized language model fully on-device via `llama.cpp`, acting as a patient, beginner-friendly Python tutor. It explains concepts, debugs code, and adapts to the learner's language (French, English, and more) — all without a single network call during inference.

## 🛠️ How It Works

- **Model:** Qwen2.5-Coder-7B-Instruct (GGUF, Q4_K_M quantization, ~4.5 GB)
- **Runtime:** [llama.cpp](https://github.com/ggerganov/llama.cpp) — CPU-only inference, no GPU required
- **Target hardware:** Tested on a 2015 dual-core laptop (Intel i5-5300U, 12 GB RAM, no dedicated GPU, HDD) — representative of real conditions for our target users
- **Languages:** French and English validated; additional languages explored (see `REPORT.md`)

## 📄 Full Technical Writeup

See [`REPORT.md`](./REPORT.md) for the complete breakdown: problem framing, design decisions, hardware constraints, and benchmark results.

## 📁 Submission Files

This repository follows the official [ADTC 2026 submission template](https://github.com/Africa-Deep-Tech-Foundation/adtc-2026-submission-template):

| File | Purpose |
|---|---|
| `metadata.json` | Team, model, and test prompt metadata |
| `download_model.sh` | Downloads the model weights to `model/` |
| `REPORT.md` | Full technical writeup |
| `model/` | Model weights (downloaded locally, not committed — see `.gitignore`) |

## 🚀 Quick Start

```bash
# Download the model
bash download_model.sh

# Run inference via llama.cpp
llama-cli -m model/qwen2.5-coder-7b-instruct-q4_k_m.gguf -t 4 -c 4096
```

## 👤 Team

Built by [Pededep Mbozeko Archille](https://github.com/Archille21) — Douala, Cameroon 🇨🇲

---

*Part of the Orange Digital Center ecosystem. Built with llama.cpp, GGUF, Qwen2.5-Coder, Python, and LM Studio.*
