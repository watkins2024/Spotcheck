# Updates nav, footer, Pricing and FAQ cross-links across all .html files.
# Idempotent: safe to run multiple times. Creates .bak once per file (first change).

$navInsertBefore = '<a href="faq.html">FAQ</a>'
$navLink         = '<a href="explainer.html">Why caretaking?</a>'
$footerBlockStart= '<div style="display:flex;gap:12px">'
$footerLink      = '<a href="explainer.html">Why caretaking?</a>'
$pricingPrimary  = '<a class="btn primary" href="contact.html">Make an enquiry</a>'
$pricingGhost    = '<a class="btn ghost" href="explainer.html">Why caretaking?</a>'
$faqCardHdr      = '<h3>Do you clean?</h3>'
$faqLinkLine     = '<p><a href="explainer.html">See our caretaking explainer →</a></p>'
$cssPlain        = 'href="styles.css"'
$cssBusted       = 'href="styles.css?v=2"'

function Insert-Nav {
  param([string]$html)
  $start = $html.IndexOf('<div class="navlinks">')
  if ($start -lt 0) { return $html }
  $end   = $html.IndexOf('</div>', $start)
  if ($end -lt 0) { return $html }
  $block = $html.Substring($start, $end - $start)
  if ($block -match 'explainer\.html') { return $html }

  if ($block.Contains($navInsertBefore)) {
    $newBlock = $block.Replace($navInsertBefore, "$navLink$navInsertBefore")
  } else {
    $newBlock = $block + $navLink
  }
  return $html.Substring(0,$start) + $newBlock + $html.Substring($end)
}

function Insert-Footer {
  param([string]$html)
  $pos = $html.IndexOf($footerBlockStart)
  if ($pos -lt 0) { return $html }
  $end = $html.IndexOf('</div>', $pos)
  if ($end -lt 0) { return $html }
  $block = $html.Substring($pos, $end - $pos)
  if ($block -match 'explainer\.html') { return $html }
  $newBlock = $block + $footerLink
  return $html.Substring(0,$pos) + $newBlock + $html.Substring($end)
}

function Insert-PricingButton {
  param([string]$html,[string]$name)
  if ($name -ne 'pricing.html') { return $html }
  if ($html -match [regex]::Escape($pricingGhost)) { return $html }
  if ($html -match [regex]::Escape($pricingPrimary)) {
    return $html -replace [regex]::Escape($pricingPrimary), ($pricingPrimary + "`n      " + $pricingGhost), 1
  }
  return $html
}

function Insert-FaqLink {
  param([string]$html,[string]$name)
  if ($name -ne 'faq.html') { return $html }
  if ($html -match [regex]::Escape($faqLinkLine)) { return $html }

  $hdr = $html.IndexOf($faqCardHdr)
  if ($hdr -lt 0) { return $html }
  $pStart = $html.IndexOf('<p', $hdr)
  $pEnd   = $html.IndexOf('</p>', $pStart)
  if ($pStart -lt 0 -or $pEnd -lt 0) { return $html }
  $insertAt = $pEnd + 4
  if ($html.Substring($pStart, $insertAt - $pStart) -match 'explainer\.html') { return $html }

  return $html.Substring(0,$insertAt) + "`n          " + $faqLinkLine + $html.Substring($insertAt)
}

function Cache-BustCss {
  param([string]$html)
  if ($html -match 'styles\.css\?v=') { return $html }
  return $html.Replace($cssPlain, $cssBusted)
}

function Process-File {
  param([string]$path)
  $original = Get-Content -Path $path -Raw -Encoding UTF8
  $updated  = $original

  $name = [System.IO.Path]::GetFileName($path)
  $updated = Insert-Nav        -html $updated
  $updated = Insert-Footer     -html $updated
  $updated = Insert-PricingButton -html $updated -name $name
  $updated = Insert-FaqLink    -html $updated -name $name
  $updated = Cache-BustCss     -html $updated

  if ($updated -ne $original) {
    $bak = "$path.bak"
    if (-not (Test-Path $bak)) {
      Set-Content -Path $bak -Value $original -Encoding UTF8
    }
    Set-Content -Path $path -Value $updated -Encoding UTF8
    Write-Host "Updated: $name"
  } else {
    Write-Host "No changes: $name"
  }
}

Get-ChildItem -Filter *.html | ForEach-Object { Process-File $_.FullName }
Write-Host "`nDone."
