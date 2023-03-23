// Written Example by Ryan Mangan
// JS script for Open AI ChatGPT Question
//



class Auth {
  constructor(apiKey, apiUrl) {
    this._apiKey = apiKey;
    this._apiUrl = apiUrl;
  }

  async getResponse(prompt, maxTokens, temperature, frequencyPenalty, presencePenalty, topP, bestOf) {
    const jsonRequest = JSON.stringify({
      prompt,
      max_tokens: maxTokens,
      temperature,
      frequency_penalty: frequencyPenalty,
      presence_penalty: presencePenalty,
      top_p: topP,
      best_of: bestOf,
      stop: null
    });

    const response = await fetch(this._apiUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'api-key': this._apiKey
      },
      body: jsonRequest
    });

    if (!response.ok) {
      throw new Error(`HTTP error! Status: ${response.status}`);
    }

    const jsonResponse = await response.text();

    // Parse the JSON response
    const responseObject = JSON.parse(jsonResponse);

    if (responseObject.hasOwnProperty('choices') && responseObject.choices.length > 0 && responseObject.choices[0].hasOwnProperty('text')) {
      // Extract the 'text' field from the response
      const text = responseObject.choices[0].text;

      return text;
    } else {
      throw new Error('Invalid response from server.');
    }
  }
}

function toggleHelpText() {
  const helpText = document.querySelector('.help-text');
  if (helpText.style.display === 'none') {
    helpText.style.display = 'block';
  } else {
    helpText.style.display = 'none';
  }
}

function copyToClipboard() {
  const resultDiv = document.getElementById('result');
  const text = resultDiv.textContent;
  const textarea = document.createElement('textarea');
  textarea.value = text;
  document.body.appendChild(textarea);
  textarea.select();
  document.execCommand('copy');
  document.body.removeChild(textarea);
  
  const copyButton = document.getElementById('copyButton');
copyButton.innerHTML = '<i class="fas fa-check"></i>'; // Change to checkmark icon
setTimeout(function() {
  copyButton.innerHTML = '<i class="fas fa-clipboard"></i>'; // Change back to clipboard icon
}, 2000);
}




async function askQuestion() {
  const apiKey = localStorage.getItem('apiKey') || '<KEY>'; // Retrieve API KEY from localStorage or use a default
  const apiUrl = localStorage.getItem('apiUrl') || 'https://<Instance>.openai.azure.com/openai/deployments/<Model>/completions?api-version=2022-12-01'; // Retrieve API URL from localStorage or use a default
  const auth = new Auth(apiKey, apiUrl);
  // ... (rest of the function remains the same)


  const questionBox = document.getElementById('question');
  const prompt = questionBox.value.trim();
  const isEmpty = prompt === '';

  if (isEmpty) {
    const errorDiv = document.getElementById('error');
    errorDiv.textContent = 'Please enter a question.';
    return;
  }

  const progressBar = document.querySelector('.loading-bar');
  progressBar.style.width = '1%'; // reset the width of the progress bar
  progressBar.style.display = 'block';

  // Add passive event listener to touchmove event
  progressBar.addEventListener('touchmove', () => {}, { passive: true });
  
  try {
    const maxTokens = 256;
    const temperature = 0.5;
    const frequencyPenalty = 0.5;
    const presencePenalty = 0.5;
    const topP = 1;
    const bestOf = 1;

    const resultDiv = document.getElementById('result');
    const errorDiv = document.getElementById('error');
    const processingDiv = document.getElementById('processing');
    resultDiv.style.display = 'none'; // hide the result initially
    errorDiv.textContent = ''; // clear any previous errors

    // check if question is empty
    if (prompt === '') {
      errorDiv.textContent = 'Please enter a question.';
      processingDiv.style.display = 'none';
      return;
    }

    // show the processing bar
    processingDiv.innerHTML = '<div class="loading-bar"></div><p>Please wait...</p>';
    processingDiv.style.display = 'block';

    const response = await auth.getResponse(prompt, maxTokens, temperature, frequencyPenalty, presencePenalty, topP, bestOf);

    // hide the processing bar
    processingDiv.style.display = 'none';
    progressBar.style.display = 'none';

    // display the response
    resultDiv.textContent = response;
    resultDiv.style.display = 'block';

    // show the "Copy to Clipboard" button
    const copyButton = document.getElementById('copyButton');
    copyButton.style.display = 'block';

  } catch (error) {
    // hide the processing bar and display an error message
    const processingDiv = document.getElementById('processing');
    processingDiv.style.display = 'none';
    const errorDiv = document.getElementById('error');
    errorDiv.textContent = 'An error occurred. Please try again later.';
    progressBar.style.display = 'none';
  }
}
function openApiForm() {
  const modal = document.getElementById('apiFormModal');
  modal.style.display = 'block';
  document.getElementById('apiKeyInput').value = localStorage.getItem('apiKey') || '';
  document.getElementById('apiUrlInput').value = localStorage.getItem('apiUrl') || '';
}

function closeApiForm() {
  const modal = document.getElementById('apiFormModal');
  modal.style.display = 'none';
}

function saveApiConfig(event) {
  event.preventDefault(); // Prevent form submission and page reload
  const apiKeyInput = document.getElementById('apiKeyInput');
  const apiUrlInput = document.getElementById('apiUrlInput');

  // Save the API key and URL to localStorage
  localStorage.setItem('apiKey', apiKeyInput.value);
  localStorage.setItem('apiUrl', apiUrlInput.value);
  
  // Close the form
  closeApiForm();
  }
  
  // Add event listeners for the close and save buttons
  document.getElementById('closeApiForm').addEventListener('click', closeApiForm);
  document.getElementById('saveApiConfig').addEventListener('click', saveApiConfig);
  
  // Add event listener to close the modal when clicking outside the modal content
  window.addEventListener('click', function(event) {
  const modal = document.getElementById('apiFormModal');
  if (event.target === modal) {
  closeApiForm();
  }
  });
  document.getElementById("infoButton").addEventListener("click", function() {
    document.getElementById("infoPopup").style.display = "block";
  });
  document.getElementById("infoPopup").addEventListener("click", function() {
    this.style.display = "none";
  });
  
  