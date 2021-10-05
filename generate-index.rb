
# OUTPUT_FILENAME = 'index-test.html'
OUTPUT_FILENAME = 'index.html'
INPUT_DIRECTORY = './40k'

def titlize(str)
    str.split(/ |\_/).map(&:capitalize).join(' ')
end

def find_armies(dir)
    armies = { }
    Dir.foreach(dir) do |filename|
        next if '.' == filename || '..' == filename
        next unless File.directory?("#{dir}/#{filename}")
        armies[filename] = "#{dir}/#{filename}"
        puts "#{filename}"
    end
    return armies
end

def get_armies(armies)
    items = [ '<ul>' ]
    armies.keys.sort.each {|army|
        item = "\t<li><a href=\"\##{army}\" >#{titlize(army)}</a></li>"
        items << item
    }
    items << '</ul>'
    items << ''
    return items
end

def get_lists(army, dir)
    lists = []
    puts "#{dir} >>>"
    Dir.foreach(dir) do |filename|
        next if '.' == filename || '..' == filename
        next unless File.file?("#{dir}/#{filename}")
        lists << filename
        puts "#{dir} >>> #{filename}"
    end
    items = [
        "<h3 id=\"#{army}\" >#{titlize(army)}</h3>",
        '<ul>'
    ]
    lists.sort.each {|list| items << "\t<li><a href=\"#{dir}/#{list}\" >#{list}</a></li>" }
    items << 'No lists...' if lists.empty?
    items << '</ul>'
    items << ''
    return items
end

File.open(OUTPUT_FILENAME, 'wt') do |file|
    file.puts(%q(<!DOCTYPE html>
<html>
    <head>
        <title>Rosters</title>
    </head>
    <body>

))
    
    armies = find_armies(INPUT_DIRECTORY)

    file.puts(get_armies(armies))
    armies.each do |entry|
        file.puts(get_lists(*entry))
    end

    file.puts(%q(    </body>
</html>))
end
