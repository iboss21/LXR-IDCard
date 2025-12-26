// v3.0 Enhanced Features JavaScript

// ============================================
// WEBCAM INTEGRATION
// ============================================

let webcamStream = null;
let retakesUsed = 0;
let maxRetakes = 3;
let capturedPhotoData = null;

function initWebcam(config) {
    maxRetakes = config.maxRetakes || 3;
    retakesUsed = 0;
    
    const constraints = {
        video: {
            width: config.resolution.width,
            height: config.resolution.height,
            facingMode: 'user'
        }
    };
    
    navigator.mediaDevices.getUserMedia(constraints)
        .then(stream => {
            webcamStream = stream;
            const video = document.getElementById('webcamVideo');
            video.srcObject = stream;
            
            document.getElementById('webcamInterface').classList.remove('hidden');
            updateRetakeCounter();
        })
        .catch(error => {
            console.error('Error accessing webcam:', error);
            sendNUICallback('webcamPhotoTaken', { success: false, error: error.message });
        });
}

function startCountdown(callback) {
    const overlay = document.getElementById('countdownOverlay');
    const number = document.getElementById('countdownNumber');
    let count = 3;
    
    overlay.classList.remove('hidden');
    
    const interval = setInterval(() => {
        if (count > 0) {
            number.textContent = count;
            count--;
        } else {
            clearInterval(interval);
            overlay.classList.add('hidden');
            callback();
        }
    }, 1000);
}

function captureWebcamPhoto(quality) {
    const video = document.getElementById('webcamVideo');
    const canvas = document.getElementById('webcamCanvas');
    const ctx = canvas.getContext('2d');
    
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    
    ctx.drawImage(video, 0, 0);
    
    // Get photo as base64
    capturedPhotoData = canvas.toDataURL('image/jpeg', quality || 0.8);
    
    // Show preview and controls
    video.style.display = 'none';
    canvas.style.display = 'block';
    
    document.getElementById('capturePhoto').classList.add('hidden');
    document.getElementById('retakePhoto').classList.remove('hidden');
    document.getElementById('confirmPhoto').classList.remove('hidden');
}

function updateRetakeCounter() {
    const counter = document.getElementById('retakeCounter');
    const left = document.getElementById('retakesLeft');
    
    if (maxRetakes > 0) {
        counter.classList.remove('hidden');
        left.textContent = maxRetakes - retakesUsed;
    }
}

// Webcam event listeners
document.getElementById('capturePhoto')?.addEventListener('click', () => {
    startCountdown(() => {
        captureWebcamPhoto(0.8);
    });
});

document.getElementById('retakePhoto')?.addEventListener('click', () => {
    if (retakesUsed < maxRetakes) {
        retakesUsed++;
        updateRetakeCounter();
        
        const video = document.getElementById('webcamVideo');
        const canvas = document.getElementById('webcamCanvas');
        
        video.style.display = 'block';
        canvas.style.display = 'none';
        
        document.getElementById('capturePhoto').classList.remove('hidden');
        document.getElementById('retakePhoto').classList.add('hidden');
        document.getElementById('confirmPhoto').classList.add('hidden');
    }
});

document.getElementById('confirmPhoto')?.addEventListener('click', () => {
    stopWebcam();
    sendNUICallback('webcamPhotoTaken', { success: true, photoData: capturedPhotoData });
});

document.getElementById('cancelWebcam')?.addEventListener('click', () => {
    stopWebcam();
    sendNUICallback('webcamPhotoTaken', { success: false });
});

function stopWebcam() {
    if (webcamStream) {
        webcamStream.getTracks().forEach(track => track.stop());
        webcamStream = null;
    }
    document.getElementById('webcamInterface').classList.add('hidden');
}

// ============================================
// PHOTO EDITOR
// ============================================

let editorImage = null;
let editorCanvas = null;
let editorCtx = null;
let currentFilter = 'none';
let currentBrightness = 100;
let currentContrast = 100;
let currentRotation = 0;

function initPhotoEditor(photoData, config) {
    editorCanvas = document.getElementById('editorCanvas');
    editorCtx = editorCanvas.getContext('2d');
    
    const img = new Image();
    img.onload = function() {
        editorImage = img;
        editorCanvas.width = img.width;
        editorCanvas.height = img.height;
        applyEdits();
    };
    img.src = photoData;
    
    document.getElementById('photoEditor').classList.remove('hidden');
}

function applyEdits() {
    if (!editorImage) return;
    
    editorCtx.save();
    editorCtx.clearRect(0, 0, editorCanvas.width, editorCanvas.height);
    
    // Apply rotation
    if (currentRotation !== 0) {
        editorCtx.translate(editorCanvas.width / 2, editorCanvas.height / 2);
        editorCtx.rotate(currentRotation * Math.PI / 180);
        editorCtx.translate(-editorCanvas.width / 2, -editorCanvas.height / 2);
    }
    
    // Draw image
    editorCtx.drawImage(editorImage, 0, 0);
    
    // Apply filters
    let filterCSS = '';
    
    // Brightness
    if (currentBrightness !== 100) {
        filterCSS += `brightness(${currentBrightness}%) `;
    }
    
    // Contrast
    if (currentContrast !== 100) {
        filterCSS += `contrast(${currentContrast}%) `;
    }
    
    // Preset filters
    switch (currentFilter) {
        case 'sepia':
            filterCSS += 'sepia(80%) contrast(120%)';
            break;
        case 'grayscale':
            filterCSS += 'grayscale(100%)';
            break;
        case 'vintage':
            filterCSS += 'sepia(50%) contrast(110%) brightness(110%)';
            break;
        case 'aged':
            filterCSS += 'sepia(90%) contrast(130%) brightness(90%)';
            break;
    }
    
    editorCanvas.style.filter = filterCSS;
    editorCtx.restore();
}

// Photo editor event listeners
document.getElementById('filterSelect')?.addEventListener('change', (e) => {
    currentFilter = e.target.value;
    applyEdits();
});

document.getElementById('brightnessSlider')?.addEventListener('input', (e) => {
    currentBrightness = e.target.value;
    document.getElementById('brightnessValue').textContent = currentBrightness;
    applyEdits();
});

document.getElementById('contrastSlider')?.addEventListener('input', (e) => {
    currentContrast = e.target.value;
    document.getElementById('contrastValue').textContent = currentContrast;
    applyEdits();
});

document.querySelectorAll('.btn-rotation').forEach(btn => {
    btn.addEventListener('click', (e) => {
        currentRotation = parseInt(e.target.dataset.angle);
        applyEdits();
    });
});

document.getElementById('resetEdits')?.addEventListener('click', () => {
    currentFilter = 'none';
    currentBrightness = 100;
    currentContrast = 100;
    currentRotation = 0;
    
    document.getElementById('filterSelect').value = 'none';
    document.getElementById('brightnessSlider').value = 100;
    document.getElementById('contrastSlider').value = 100;
    document.getElementById('brightnessValue').textContent = 100;
    document.getElementById('contrastValue').textContent = 100;
    
    applyEdits();
});

document.getElementById('confirmEdits')?.addEventListener('click', () => {
    const editedPhoto = editorCanvas.toDataURL('image/jpeg', 0.8);
    document.getElementById('photoEditor').classList.add('hidden');
    sendNUICallback('photoEditComplete', { confirmed: true, editedPhoto: editedPhoto });
});

document.getElementById('cancelEdits')?.addEventListener('click', () => {
    document.getElementById('photoEditor').classList.add('hidden');
    sendNUICallback('photoEditComplete', { confirmed: false });
});

// ============================================
// ADVANCED STATISTICS
// ============================================

let statisticsCharts = {};

function initAdvancedStatistics(data, config) {
    // Update metric cards
    document.getElementById('totalApplications').textContent = data.applications || 0;
    document.getElementById('totalApprovals').textContent = data.approvals || 0;
    document.getElementById('totalDenials').textContent = data.denials || 0;
    document.getElementById('pendingApplications').textContent = data.pending || 0;
    document.getElementById('totalReplacements').textContent = data.replacements || 0;
    document.getElementById('totalRenewals').textContent = data.renewals || 0;
    
    // Create charts if enabled
    if (config.features.charts && typeof Chart !== 'undefined') {
        createStatisticsCharts(data);
    }
    
    document.getElementById('advancedStatistics').classList.remove('hidden');
}

function createStatisticsCharts(data) {
    // Applications over time chart
    if (data.applicationsOverTime) {
        const ctx = document.getElementById('applicationsChart').getContext('2d');
        statisticsCharts.applications = new Chart(ctx, {
            type: 'line',
            data: {
                labels: data.applicationsOverTime.labels,
                datasets: [{
                    label: 'Applications',
                    data: data.applicationsOverTime.values,
                    borderColor: '#B8860B',
                    backgroundColor: 'rgba(184, 134, 11, 0.2)',
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { display: false }
                }
            }
        });
    }
    
    // Tier distribution chart
    if (data.tierDistribution) {
        const ctx = document.getElementById('tierChart').getContext('2d');
        statisticsCharts.tiers = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: data.tierDistribution.labels,
                datasets: [{
                    data: data.tierDistribution.values,
                    backgroundColor: ['#8b6f47', '#b8860b', '#ffd700']
                }]
            },
            options: {
                responsive: true
            }
        });
    }
    
    // Approval rate chart
    if (data.approvalRate) {
        const ctx = document.getElementById('approvalChart').getContext('2d');
        statisticsCharts.approval = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Approved', 'Denied', 'Pending'],
                datasets: [{
                    data: [data.approvals, data.denials, data.pending],
                    backgroundColor: ['#4CAF50', '#F44336', '#FFC107']
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { display: false }
                }
            }
        });
    }
}

// Statistics event listeners
document.getElementById('closeStats')?.addEventListener('click', () => {
    document.getElementById('advancedStatistics').classList.add('hidden');
    // Destroy charts
    Object.values(statisticsCharts).forEach(chart => chart.destroy());
    statisticsCharts = {};
});

document.getElementById('refreshStats')?.addEventListener('click', () => {
    sendNUICallback('refreshStatistics', {});
});

document.getElementById('exportCSV')?.addEventListener('click', () => {
    sendNUICallback('exportStatistics', { format: 'csv' });
});

document.getElementById('exportJSON')?.addEventListener('click', () => {
    sendNUICallback('exportStatistics', { format: 'json' });
});

document.getElementById('filterStats')?.addEventListener('click', () => {
    document.getElementById('dateFilterPanel').classList.toggle('hidden');
});

document.getElementById('applyFilter')?.addEventListener('click', () => {
    const startDate = document.getElementById('startDate').value;
    const endDate = document.getElementById('endDate').value;
    sendNUICallback('exportStatistics', { 
        format: 'filtered',
        dateRange: { start: startDate, end: endDate }
    });
});

// ============================================
// SEASONAL BANNER
// ============================================

function showSeasonalBanner(season) {
    const banner = document.getElementById('seasonalBanner');
    const icon = document.getElementById('seasonalIcon');
    const title = document.getElementById('seasonalTitle');
    const message = document.getElementById('seasonalMessage');
    
    icon.textContent = season.badge;
    title.textContent = season.label + ' Active!';
    message.textContent = season.message || 'Enjoy seasonal benefits';
    
    banner.classList.remove('hidden');
    
    setTimeout(() => {
        banner.classList.add('hidden');
    }, 10000); // Hide after 10 seconds
}

// ============================================
// HELPER FUNCTIONS
// ============================================

function sendNUICallback(callback, data) {
    fetch(`https://tlw_idcard/${callback}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    });
}

// ============================================
// MESSAGE HANDLER ADDITIONS
// ============================================

window.addEventListener('message', (event) => {
    const data = event.data;
    
    switch (data.action) {
        case 'openWebcam':
            initWebcam(data.config);
            break;
            
        case 'openPhotoEditor':
            initPhotoEditor(data.photoData, data.config);
            break;
            
        case 'showAdvancedStatistics':
            initAdvancedStatistics(data.data, data.config);
            break;
            
        case 'showSeasonalBanner':
            showSeasonalBanner(data.season);
            break;
    }
});
