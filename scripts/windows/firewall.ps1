# ============================================================
# Windows Firewall Hardening
# Run as Administrator
# ============================================================

# --- Block all inbound on all profiles ---
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
Set-NetFirewallProfile -Profile Domain,Public,Private -DefaultInboundAction Block
Set-NetFirewallProfile -Profile Domain,Public,Private -DefaultOutboundAction Allow

# --- Disable inbound notifications (no popup asking to allow) ---
Set-NetFirewallProfile -Profile Domain,Public,Private -NotifyOnListen False

# --- Block inbound even when Windows Firewall is off for an app ---
Set-NetFirewallProfile -Profile Domain,Public,Private -AllowInboundRules False

# --- Remove all pre-existing inbound allow rules (optional but thorough) ---
# WARNING: This removes ALL built-in inbound allow rules.
# Comment out if you use RDP, file sharing, etc.
Get-NetFirewallRule -Direction Inbound -Action Allow | Remove-NetFirewallRule

# --- Re-allow only what you actually need (add your own below) ---
# Example: Allow inbound on a specific port if needed
# New-NetFirewallRule -DisplayName "Allow SSH" -Direction Inbound -Protocol TCP -LocalPort 22 -Action Allow

# --- Verify ---
Get-NetFirewallProfile | Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction
