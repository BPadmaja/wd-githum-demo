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
dns_raw = File.readlines("zone")
# ..
# ..
def parse_dns(dns_raw)
  dns_raw = dns_raw.map(&:strip).delete_if {|text| text.length == 0 }
  dns_raw=dns_raw[1..-1]
  data=Array.new(5){Array.new(3)}
  rows=[]
  no_of_rec=5
  no_of_cols=3
     for rind in 0...no_of_rec
         all_r=dns_raw[rind].strip.split(",")
         for cind in 0...no_of_cols
             data[rind][cind]=all_r[cind].strip
          end
     end
     
  # Hash[data.map {|key,k,t| [k,{:type=>key,:target=>t}]}]
    Hash[data.map {|key,dname,ip_addr| [dname,{:type=>key,:target=>ip_addr}]}]
end

def resolve(dns_records, lookup_chain, domain)
    record = dns_records[domain]
    if (!record)
      lookup_chain=["Error: Record not found for #{domain}"]
      return lookup_chain
    elsif record[:type] == "CNAME"
      lookup_chain.push(record[:target])
      resolve(dns_records,lookup_chain,record[:target])
    elsif record[:type] == "A"
      lookup_chain.push(record[:target])
      return lookup_chain
    end
end

# ..
# ..

# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
