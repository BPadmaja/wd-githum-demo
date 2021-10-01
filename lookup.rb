
 def get_command_line_argument
  # ARGV is an array that Ruby defines for us,
  # which contains all the arguments we passed to it
  # when invoking the script from the command line.
  # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end

# `domain` contains the domain name we have to look up.
domain = get_command_line_argument

# File.readlines reads a file and returns an
# array of string, where each element is a line
# https://www.rubydoc.info/stdlib/core/IO:readlines
# dns_raw = File.readlines("zone").each do |line|
#  puts line
# end
dns_raw = File.readlines("zone")
puts "BEFORE delete "
puts dns_raw
puts "after delete "
# dns_records=dns_raw.delete_if { |dns_raw| dns_raw.length == 0 || dns_raw[0]=='#'}
# puts dns_records
def parse_dns(dns_raw)
puts "i m here"
dns_records=dns_raw.delete_if { |dns_raw| dns_raw.length == 0 || dns_raw[0]=='#'}
return dns_records
end

def resolve(dns_records,lookup_chain,domain)

if dns_records[domain][:type]== "A"
  lookup_chain.push(dns_records[domain][:target])
elsif dns_records[domain][:type] == "CNAME"
  lookup_chain.push(dns_records[domain][:target])
  resolve(dns_records, lookup_chain, dns_records[domain][:target])
end
end     


dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
