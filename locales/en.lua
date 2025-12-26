-- English Locale
Locales['en'] = {
    -- Photographer
    photographer_prompt = 'Take Mugshot Photo',
    photographer_busy = 'The photographer is busy with another customer',
    photographer_cooldown = 'You must wait before taking another photo',
    photographer_insufficient_funds = 'You need $%s to take a photo',
    photographer_success = 'Photo taken! You received a Photo Plate.',
    
    -- Government Office
    government_prompt = 'Submit Citizenship Application',
    government_no_photo = 'You need a Photo Plate to apply for citizenship',
    government_cooldown = 'You must wait before submitting another application',
    government_insufficient_funds = 'You need $%s for the application fee',
    government_success = 'Application submitted! The Governor\'s Office will review your worthiness...',
    government_pending_received = 'You received a Resident Permit. Await approval for full citizenship.',
    
    -- Approval
    approval_success = 'You are now recognized as a Citizen of The Land of Wolves!',
    approval_admin_success = 'Citizenship approved for %s',
    approval_not_found = 'Player not found or has no pending application',
    
    -- ID Card
    card_title = 'THE LAND OF WOLVES',
    card_subtitle = 'TERRITORIAL IDENTIFICATION',
    card_pending = 'RESIDENT PERMIT',
    card_pending_subtitle = 'PENDING FULL CITIZENSHIP',
    card_approved = 'APPROVED - CITIZEN',
    
    -- Camera
    camera_preparing = 'Preparing camera...',
    camera_smile = 'Hold still for your mugshot!',
    camera_success = 'Photo captured successfully!',
    
    -- Inspection
    inspection_prompt = 'Inspect ID Card',
    inspection_request_sent = 'Inspection request sent to %s',
    inspection_request_received = '%s wants to inspect your ID. Accept?',
    inspection_denied = 'ID inspection was denied',
    inspection_too_far = 'You are too far away to inspect their ID',
    inspection_no_id = 'That person is not showing an ID card',
    
    -- Replacement
    replacement_prompt = 'Replace Lost/Stolen ID',
    replacement_success = 'ID card replaced successfully!',
    replacement_cooldown = 'You must wait %s before replacing your ID again',
    replacement_max_reached = 'You have reached the maximum number of replacements',
    replacement_insufficient_funds = 'You need $%s to replace your ID',
    replacement_no_previous = 'You have no previous ID to replace',
    
    -- Expiration/Renewal
    expiration_warning = 'Your ID will expire in %s days!',
    expiration_expired = 'Your ID has expired! Visit a government office to renew it.',
    renewal_prompt = 'Renew Citizenship',
    renewal_success = 'ID renewed successfully! Valid for 30 more days.',
    renewal_insufficient_funds = 'You need $%s to renew your ID',
    renewal_not_expired = 'Your ID is still valid',
    
    -- Tiers
    tier_basic = 'Basic Citizenship',
    tier_premium = 'Premium Citizenship',
    tier_elite = 'Elite Citizenship',
    tier_upgrade_prompt = 'Upgrade Citizenship Tier',
    tier_upgrade_success = 'Upgraded to %s!',
    tier_benefits = 'Benefits: %s',
    
    -- v3.0 Features
    webcam_permission = 'Allow camera access to take your photo',
    webcam_countdown = 'Photo in %s seconds...',
    webcam_retake = 'Retake Photo',
    webcam_confirm = 'Use This Photo',
    webcam_failed = 'Failed to access webcam. Falling back to in-game camera.',
    
    photo_edit_title = 'Edit Your Photo',
    photo_filter = 'Apply Filter',
    photo_brightness = 'Brightness',
    photo_contrast = 'Contrast',
    photo_rotate = 'Rotate',
    photo_done = 'Done Editing',
    
    card_design_select = 'Choose ID Card Design',
    card_design_change = 'Change ID Design',
    card_design_changed = 'ID card design changed!',
    
    family_tier_prompt = 'Create Family Citizenship',
    family_member_add = 'Add Family Member',
    family_package_created = 'Family citizenship package created!',
    family_insufficient_members = 'You need at least %s members for this package',
    
    seasonal_bonus_active = 'Seasonal Bonus Active: %s',
    seasonal_discount_applied = 'Seasonal discount applied: %s%%',
    
    stats_export_csv = 'Export to CSV',
    stats_export_json = 'Export to JSON',
    stats_filter_dates = 'Filter by Date Range',
    stats_refresh = 'Refresh Data',
    
    language_select = 'Select Language',
    language_changed = 'Language changed to %s',
    
    custom_tier_create = 'Create Custom Tier',
    custom_tier_created = 'Custom citizenship tier created!',
    custom_tier_max_reached = 'Maximum custom tiers reached',
    
    perk_activated = 'Tier perk activated: %s',
    perk_shop_discount = 'Shop discount applied: %s%%',
    perk_job_bonus = 'Job pay bonus: +%s%%',
    
    job_citizenship_required = 'This job requires citizenship',
    job_tier_required = 'This job requires %s tier or higher',
    job_bonus_active = 'Citizenship job bonus active',
    
    property_citizenship_required = 'Citizenship required to purchase property',
    property_discount_applied = 'Citizenship discount applied: %s%%',
    property_limit_reached = 'You have reached your property limit for your tier',
    
    criminal_record_warning = 'Criminal record may affect citizenship approval',
    criminal_record_tier_denied = 'Criminal record prevents %s tier citizenship',
    criminal_appeal_prompt = 'Appeal Criminal Record',
    criminal_appeal_success = 'Criminal record appeal submitted',
}
