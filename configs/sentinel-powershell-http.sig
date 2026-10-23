signature seq_sentinel_powershell_http {
    ip-proto == tcp
    dst-port == 80, 8080, 8443
    http-request-header /.*PowerShell.*/
    event "Operation Sentinel: Outbound PowerShell HTTP Request Detected"
}
