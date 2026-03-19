alter table population add column PTOT integer generated always as(pmun + pcap) virtual
