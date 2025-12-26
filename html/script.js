// Get resource name
function GetParentResourceName() {
    let parts = window.location.pathname.split('/');
    return parts[parts.length - 3];
}

// Post data to Lua
function post(url, data = {}) {
    return fetch(`https://${GetParentResourceName()}/${url}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
    });
}

// Close UI on ESC key
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeUI();
    }
});

// Close UI function
function closeUI() {
    document.getElementById('applicationForm').classList.add('hidden');
    document.getElementById('cardDisplay').classList.add('hidden');
    post('close');
}

// ==================== APPLICATION FORM ==================== //

// Handle form submission
document.getElementById('citizenshipForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    // Get form data
    const formData = {
        fullname: document.getElementById('fullname').value.trim(),
        birthdate: document.getElementById('birthdate').value.trim(),
        birthplace: document.getElementById('birthplace').value.trim(),
        occupation: document.getElementById('occupation').value.trim(),
        reason: document.getElementById('reason').value.trim()
    };
    
    // Validate
    for (let key in formData) {
        if (!formData[key]) {
            showNotification('Please fill in all required fields', 'error');
            return;
        }
    }
    
    // Submit to server
    post('submitApplication', formData).then(() => {
        // Clear form
        document.getElementById('citizenshipForm').reset();
        // Close UI
        closeUI();
    });
});

// Handle cancel button
document.getElementById('cancelBtn').addEventListener('click', function() {
    document.getElementById('citizenshipForm').reset();
    closeUI();
});

// ==================== ID CARD DISPLAY ==================== //

// Show notification (optional - can be removed if using game notifications)
function showNotification(message, type) {
    console.log(`[${type.toUpperCase()}] ${message}`);
}

// ==================== MESSAGE HANDLER ==================== //

window.addEventListener('message', function(event) {
    const data = event.data;
    
    switch(data.action) {
        case 'openForm':
            openApplicationForm(data);
            break;
        case 'showCard':
            showIDCard(data);
            break;
    }
});

// Open application form
function openApplicationForm(data) {
    const form = document.getElementById('applicationForm');
    form.classList.remove('hidden');
    
    // Focus first input
    setTimeout(() => {
        document.getElementById('fullname').focus();
    }, 100);
}

// Show ID card
function showIDCard(data) {
    const cardDisplay = document.getElementById('cardDisplay');
    const stampOverlay = document.getElementById('stampOverlay');
    
    // Set card data
    document.getElementById('cardName').textContent = data.data.fullname || 'Unknown';
    document.getElementById('cardBirthdate').textContent = data.data.birthdate || 'Unknown';
    document.getElementById('cardBirthplace').textContent = data.data.birthplace || 'Unknown';
    document.getElementById('cardOccupation').textContent = data.data.occupation || 'Unknown';
    document.getElementById('cardCitizenId').textContent = data.data.citizenid || 'XXXX-XXXX';
    document.getElementById('cardIssued').textContent = data.data.issued || '00/00/0000';
    document.getElementById('governorName').textContent = data.governor || 'Territorial Governor';
    
    // Set card type and status
    const docType = document.getElementById('cardDocType');
    const statusText = document.getElementById('cardStatus');
    
    if (data.data.status === 'approved') {
        docType.textContent = 'TERRITORIAL IDENTIFICATION';
        statusText.textContent = 'CITIZEN OF THE LAND OF WOLVES';
        
        // Show stamp with animation
        stampOverlay.classList.remove('hidden');
    } else {
        docType.textContent = 'RESIDENT PERMIT';
        statusText.textContent = 'PENDING FULL CITIZENSHIP';
        
        // Hide stamp
        stampOverlay.classList.add('hidden');
    }
    
    // Show card
    cardDisplay.classList.remove('hidden');
}

// Debug logging
console.log('The Land of Wolves - ID Card System Loaded');
