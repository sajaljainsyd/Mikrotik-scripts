{
:local targetIP "192.168.12.5"  # Change this to the IP address you want to ping
:local zerotierInterface "zerotierpl" # Change this to your ZeroTier interface name

:log info "Starting ping script"

:local failureCount 0

:while (true) do={
    :if ([ping $targetIP count=3] = 0) do={
        :log warning "Ping to $targetIP failed. Disabling ZeroTier interface"
        /interface set $zerotierInterface disabled=yes
        :delay 30s # Change the delay accordingly
        :log info "Enabling ZeroTier interface"
        /interface set $zerotierInterface disabled=no
        
        :set failureCount ($failureCount + 1)
        
        :if ($failureCount >= 10) do={
            :log warning "Ping failed for 10 consecutive times. Exiting the loop."
            :delay 1s
            /quit
        }
    } else={
        :set failureCount 0
    }
    :delay 1s
}
}