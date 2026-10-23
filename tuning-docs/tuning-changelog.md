## Network Rule Tuning: Zeek DNS Anomaly Script

* **Initial Rule:** Alerted on any DNS query string exceeding 45 characters.
* **Observed Noise:** Local mDNS service discovery queries (`._spotify-connect._tcp.local`) generated continuous false positives.
* **Applied Exclusion:** Added string suffix check `/\.local$/` to bypass internal broadcast discovery while retaining alerts for external query tunneling.
