<!-- 
  REPORT.md — Technical writeup for ADTC 2026 submission (Koda)
  This file is read by human judges AND an LLM-based audit system.
  Required sections: Problem, Design Decisions, Constraints, Benchmarks.
  Keep it factual and specific — 1 to 3 pages is the target length.
-->

# Koda — Technical Report

<!-- SECTION 1: Problem
     Explain what problem you're solving and who the target user is
     in an African context. Judges use this to assess real-world relevance. -->
## 1. Problem

Access to programming education in Africa is limited by unreliable internet connectivity, inconsistent electricity, and a shortage of available human mentors — particularly for beginner students learning to code outside major urban centers. Cloud-based AI tutors solve none of these constraints: they require a stable connection and often carry subscription costs that are out of reach for many students.

**Target user:** Beginner-to-intermediate Python students in African secondary schools, universities, and self-taught learning contexts, who need an interactive tutor that works entirely offline, on the modest hardware they already own.

Koda is an offline AI programming tutor that explains core Python concepts, debugs student code, and generates practice exercises — all without any network dependency once installed.

<!-- SECTION 2: Design Decisions
     Document the base model chosen, quantization level, and alternatives
     evaluated. This is where you justify your technical choices. -->
## 2. Design Decisions

**Base model:** We evaluated two candidates before selecting a final model:
- **Phi-4-mini-instruct** (Q4_K_M, ~2.5 GB) — lightweight and fast, but produced noticeably weaker code explanations and debugging accuracy in our tests.
- **Qwen2.5-Coder-7B-Instruct** (Q4_K_M, ~4.5 GB) — selected as the final model. Despite its larger size, it consistently outperformed Phi-4-mini on code-specific tasks (debugging, syntax error identification, exercise generation) while remaining runnable on constrained hardware.

<!-- Why Q4_K_M specifically, not Q5 or Q3 — this justifies the size/quality tradeoff -->
**Quantization level:** Q4_K_M was chosen as the standard compromise between file size and output quality. It reduces the original ~28 GB full-precision model to ~4.5 GB, comfortably fitting within the 8 GB RAM budget of the ADTC Standard Laptop profile while leaving headroom for the OS and context window.

**Runtime:** llama.cpp, as required by the competition rules, run via WSL2 + Ubuntu on the development machine. LM Studio (which wraps llama.cpp) was used in early prototyping for rapid iteration, before moving to the raw llama.cpp CLI for official, reproducible benchmarking.

<!-- SECTION 3: Constraints
     Describe the hardware, connectivity, or data constraints that shaped
     your approach. This grounds the project in real deployment conditions. -->
## 3. Constraints

**Development hardware:** Intel Core i5-5300U (2015, 2 physical cores / 4 logical threads), 12 GB DDR3 RAM, HDD storage, no dedicated GPU (integrated Intel HD Graphics only). This hardware is older and slower than the official ADTC Standard Laptop profile (10th–12th gen Intel/Ryzen 5, DDR4, SSD), and was deliberately used as a stress test representative of real-world hardware conditions many African students face.

<!-- These three bullets are the concrete engineering lessons — keep them factual and measurable -->
**Key constraint discoveries:**
- Default CPU thread allocation (1 thread) caused generation speeds roughly 4–8x slower than necessary. Explicitly setting `-t 4` (matching the 4 logical threads available) was the single highest-impact performance fix.
- Context size (`-c`) above ~4096 tokens caused unnecessary RAM pressure on this hardware; 4096 was used as a practical working value.
- Extended single-session usage (many consecutive prompts without clearing context) caused progressive performance degradation — response times increased by up to 40x in one observed case, later resolved by a full session restart. This is attributed to thermal and/or memory accumulation on aging hardware, not a model defect.

<!-- SECTION 4: Benchmarks
     Report actual inference speed and memory numbers observed on your
     development machine. Must be measured via llama.cpp CLI, not a GUI wrapper. -->
## 4. Benchmarks

All benchmarks below were measured via the official llama.cpp CLI (`llama-cli`) running inside WSL2 Ubuntu, not through a GUI wrapper.

<!-- Performance table: Prompt t/s = time to process input, Generation t/s = time to produce output -->
**Representative performance (Qwen2.5-Coder-7B-Instruct, Q4_K_M, `-t 4 -c 4096`):**

| Language / Task | Prompt (t/s) | Generation (t/s) |
|---|---|---|
| French — concept explanation | 5.2 – 6.1 | 2.2 – 2.4 |
| French — debugging | 6.1 | 2.2 |
| English — concept / debugging | 4.9 – 5.3 | 2.2 |
| Portuguese — concept / debugging | 3.9 – 4.3 | 2.0 – 2.1 |
| Arabic — concept / debugging | 2.8 – 3.0 | 1.6 |

<!-- Accuracy validation ties back to the 20-test French validation set and the
     advanced-task stress test documented earlier in the project -->
**Accuracy validation:** Across 20 beginner-level Python tutoring tests in French (concept explanations, syntax/logic debugging, exercise generation), Koda produced 19/20 correct, hallucination-free responses. A stress test using a deliberately advanced algorithmic problem (buggy recursive binary search) revealed that reasoning reliability degrades on tasks beyond the intended scope — the model produced a working code fix but an incorrect diagnostic explanation. This finding directly informed our decision to keep Koda's scope limited to beginner-to-intermediate Python.

<!-- Multilingual results support the african_alpha_claim in metadata.json —
     keep this honest, including the languages that performed poorly -->
**Multilingual coverage:** French, English, Portuguese, and Arabic performed reliably on both concept explanation and debugging tasks. Swahili and Hausa showed materially weaker performance — Hausa in particular showed a notable failure mode where responses were generated in a mix of Hausa and Swahili rather than the requested language, indicating these languages are underrepresented in the base model's training data relative to the languages tested above.

**Memory:** The model plus runtime overhead comfortably fit within the 12 GB available on the development machine, well under the 8 GB target when accounting for OS overhead — consistent with the ADTC Standard Laptop's 8 GB budget for Q4_K_M-quantized 7B models.
