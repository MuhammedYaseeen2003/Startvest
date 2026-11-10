import google.generativeai as genai
from typing import Optional

GEMINI_API_KEY="AQ.Ab8RN6I4uX6MyR5H-nW0ihYWFicea5uMT2G8BKE3U27-P0XjiA"
def reface_text_with_gemini(
        text: str,
        tone: Optional[str] = "professional",
        max_retries: int = 3
) -> str:
    """
    Send text to Gemini API for refacing (rewriting/rephrasing) and return the result.

    Args:
        text: The input text to be refaced
        api_key: Your Google Gemini API key
        tone: Desired tone for the refaced text (professional, casual, friendly, formal, concise)
        max_retries: Maximum number of retry attempts if API call fails

    Returns:
        Refaced text as string

    Raises:
        Exception: If API call fails after max retries
    """

    # Configure the Gemini API
    genai.configure(api_key=GEMINI_API_KEY)

    # Initialize the model
    model = genai.GenerativeModel('gemini-2.5-flash-lite')

    # Create the prompt for refacing
    prompt = f"""Please reface/rewrite the following text with a {tone} tone. 
    Maintain the core meaning and key information while improving clarity, flow, and style.

    Original text:
    {text}

    Refaced version (only return the rewritten text, no explanations):"""

    # Make API call with retry logic
    for attempt in range(max_retries):
        try:
            response = model.generate_content(prompt)

            # Extract and clean the response
            refaced_text = response.text.strip()

            # Remove any extra quotes if present
            refaced_text = refaced_text.strip('"\'')

            return refaced_text

        except Exception as e:
            if attempt == max_retries - 1:
                raise Exception(f"Failed to reface text after {max_retries} attempts: {str(e)}")
            print(f"Attempt {attempt + 1} failed. Retrying...")

    return ""  # Fallback return (should never reach here)


