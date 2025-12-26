-- Locales System for Multi-Language Support
Locales = {}
CurrentLocale = Config.MultiLanguage.defaultLanguage or 'en'

function _(str, ...)
    if Locales[CurrentLocale] and Locales[CurrentLocale][str] then
        return string.format(Locales[CurrentLocale][str], ...)
    elseif Locales['en'] and Locales['en'][str] then
        return string.format(Locales['en'][str], ...)
    else
        return str
    end
end

function SetLocale(locale)
    if Locales[locale] then
        CurrentLocale = locale
        return true
    end
    return false
end

function GetAvailableLocales()
    local available = {}
    for locale, _ in pairs(Locales) do
        table.insert(available, locale)
    end
    return available
end
