# /multi - Compare and fuse responses from multiple models

## Description
Sends a prompt to both Claude Sonnet 3.7 and the latest GPT model, compares their outputs, and creates a fused response that combines the best elements from both.

## MCP to use 
just-prompt

## Usage
```
/multi <prompt>
```

## Example
```
/multi Explain quantum computing in simple terms
```

## Implementation
```typescript
async function handler(prompt: string) {
  // Send the prompt to both models
  const result = await claudeCode.invoke("mcp__just-prompt__prompt", {
    text: prompt,
    models_prefixed_by_provider: ["anthropic:claude-3-7-sonnet-20250219", "openai:gpt-4-turbo"]
  });

  // Parse the responses from both models
  const responses = result.split("Model:").filter(r => r.trim());
  
  // Extract model names and their responses
  const modelOutputs = responses.map(response => {
    const lines = response.trim().split("\n");
    const model = lines[0].trim();
    const output = lines.slice(1).join("\n").replace("Response:", "").trim();
    return { model, output };
  });
  
  // Display individual responses
  console.log("Individual model responses:");
  modelOutputs.forEach(({ model, output }) => {
    console.log(`\n=== ${model} ===\n${output}`);
  });
  
  // Now ask Claude to analyze and fuse the responses
  const fusionPrompt = `
I have responses from multiple AI models to the following prompt:
"${prompt}"

Here are their responses:
${modelOutputs.map(({ model, output }) => `=== ${model} ===\n${output}`).join("\n\n")}

Please analyze these responses and create a single fused response that:
1. Combines the unique strengths and insights from each model
2. Eliminates any redundancy
3. Corrects any factual errors by choosing the most accurate information
4. Preserves the most clear and helpful explanations
5. Integrates diverse perspectives when appropriate

Return ONLY the fused response without any explanation of your analysis process.
`;

  // Use Claude to analyze and fuse the responses
  const fusedResponse = await claudeCode.message(fusionPrompt);
  
  // Return the fused response
  return fusedResponse;
}

module.exports = { handler };
```
