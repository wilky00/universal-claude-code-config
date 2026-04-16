# AI & LLM Patterns

## Prompt Formatting
- Prompts are file-based — never inline long prompt strings in code
- Store prompts as `.md` or `.txt` files, loaded at runtime
- Use clear role/instruction/input separation in prompts
- Version prompts alongside code — changes to prompts are changes to behavior

## Anthropic / Claude API
- Always use `claude-sonnet-4-6` as the default model unless a specific reason to change
- Use typed Pydantic schemas for all LLM input/output — never raw dicts
- Set explicit `max_tokens` — never rely on defaults
- Handle rate limits and API errors explicitly with retry logic

## Ollama / Local Models
- Use Ollama for local model inference
- Model name must come from config/environment — never hardcoded
- Local models are for dev/testing; production uses the Anthropic API unless specified

## Agent & Tool Patterns
- Tools must have clear, descriptive names and docstrings — the LLM reads them
- Keep individual tools small and single-purpose
- Validate tool inputs and outputs with Pydantic
- Log all LLM calls (model, token usage, latency) for observability
- Never expose raw LLM output to end users without validation or sanitization

## Security
- Never pass raw user input directly into prompts without sanitization
- Treat prompt injection as a real attack vector — validate and constrain LLM inputs
- Do not trust LLM output for security-sensitive decisions without independent verification
- Strip or escape any user-supplied content that will be interpolated into system prompts

## Cost and Usage
- Track token usage and estimated cost per call or per workflow
- Set budget alerts or hard limits where practical to prevent runaway spend
- Prefer smaller, cheaper models for simple classification or extraction tasks
- Cache deterministic or near-deterministic LLM responses when the input is stable

## Reliability and Fallbacks
- Define fallback behavior when the LLM API is unavailable or returns errors
- Implement circuit breakers or backoff strategies for sustained API failures
- Do not let a single failed LLM call crash an entire workflow — degrade gracefully
- Set reasonable timeouts on all LLM calls to avoid hanging requests
