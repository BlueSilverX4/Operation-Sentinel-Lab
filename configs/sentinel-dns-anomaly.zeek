module OperationSentinel;

export {
    redef enum Notice::Type += {
        Suspicious_DNS_Lookup
    };
}

event dns_request(c: connection, msg: dns_msg, query: string, qtype: count, qclass: count)
    {
    # Exclude benign mDNS/local network traffic (.local domains)
    if ( /\.local$/ in query )
        return;

    # Trigger notice only for external queries exceeding length threshold
    if ( |query| > 45 )
        {
        NOTICE([$note=Suspicious_DNS_Lookup,
                $msg=fmt("Operation Sentinel: Abnormally long DNS lookup detected: %s", query),
                $conn=c,
                $identifier=cat(c$id$orig_h, query)]);
        }
    }
