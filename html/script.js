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
    document.getElementById('statisticsDisplay').classList.add('hidden'); // Phase 6
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
        case 'showStatistics': // Phase 6
            showStatistics(data);
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
    
    // Phase 1: Show mugshot if available
    const photoPlaceholder = document.getElementById('photoPlaceholder');
    const photoImage = document.getElementById('photoImage');
    if (data.data.photodata) {
        photoPlaceholder.classList.add('hidden');
        photoImage.src = data.data.photodata;
        photoImage.classList.remove('hidden');
    } else {
        photoImage.classList.add('hidden');
        photoPlaceholder.classList.remove('hidden');
    }
    
    // Phase 4: Show expiration date if available
    const expirationRow = document.getElementById('expirationRow');
    if (data.data.expiration) {
        const expDate = new Date(data.data.expiration);
        document.getElementById('cardExpiration').textContent = 
            (expDate.getMonth() + 1).toString().padStart(2, '0') + '/' + 
            expDate.getDate().toString().padStart(2, '0') + '/' + 
            expDate.getFullYear();
        expirationRow.classList.remove('hidden');
    } else {
        expirationRow.classList.add('hidden');
    }
    
    // Phase 5: Show tier badge if available
    const tierBadge = document.getElementById('tierBadge');
    if (data.data.tier) {
        const tierConfig = {
            'Basic': { icon: '📋', color: '#8b6f47' },
            'Premium': { icon: '⭐', color: '#b8860b' },
            'Elite': { icon: '👑', color: '#ffd700' }
        };
        
        const tier = tierConfig[data.data.tier] || tierConfig['Basic'];
        document.getElementById('tierBadgeIcon').textContent = tier.icon;
        document.getElementById('tierBadgeText').textContent = data.data.tier;
        tierBadge.style.borderColor = tier.color;
        tierBadge.style.color = tier.color;
        tierBadge.classList.remove('hidden');
    } else {
        tierBadge.classList.add('hidden');
    }
    
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

// Phase 6: Show statistics dashboard
function showStatistics(data) {
    const statsDisplay = document.getElementById('statisticsDisplay');
    
    // Set stat values
    document.getElementById('statApplications').textContent = data.data.applications || 0;
    document.getElementById('statApprovals').textContent = data.data.approvals || 0;
    document.getElementById('statDenials').textContent = data.data.denials || 0;
    document.getElementById('statPending').textContent = data.data.pending || 0;
    document.getElementById('statReplacements').textContent = data.data.replacements || 0;
    document.getElementById('statRenewals').textContent = data.data.renewals || 0;
    
    // Show tier distribution
    const tierBars = document.getElementById('tierBars');
    tierBars.innerHTML = '';
    
    if (data.data.tierDistribution) {
        const total = Object.values(data.data.tierDistribution).reduce((a, b) => a + b, 0);
        
        for (const [tier, count] of Object.entries(data.data.tierDistribution)) {
            const percentage = total > 0 ? (count / total * 100).toFixed(1) : 0;
            
            const tierConfig = {
                'Basic': { icon: '📋', color: '#8b6f47' },
                'Premium': { icon: '⭐', color: '#b8860b' },
                'Elite': { icon: '👑', color: '#ffd700' }
            };
            
            const config = tierConfig[tier] || tierConfig['Basic'];
            
            const tierBar = document.createElement('div');
            tierBar.className = 'tier-bar';
            tierBar.innerHTML = `
                <div class="tier-bar-label">
                    <span class="tier-bar-icon">${config.icon}</span>
                    <span class="tier-bar-name">${tier}</span>
                    <span class="tier-bar-count">${count} (${percentage}%)</span>
                </div>
                <div class="tier-bar-fill-bg">
                    <div class="tier-bar-fill" style="width: ${percentage}%; background-color: ${config.color}"></div>
                </div>
            `;
            tierBars.appendChild(tierBar);
        }
    }
    
    // Show statistics display
    statsDisplay.classList.remove('hidden');
}

// Close button for statistics
document.getElementById('statsCloseBtn').addEventListener('click', closeUI);

// Debug logging
console.log('The Land of Wolves - ID Card System Loaded');
