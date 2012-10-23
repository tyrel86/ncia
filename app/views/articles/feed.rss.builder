xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "The National Voice for the Cannabis Industry"
    xml.description "The National Cannabis Industry Association (NCIA) is the only trade association in the U.S. that works to advance the interests of cannabis-related businesses on the national level."
    xml.link articles_url

    @articles.each do |article|
      xml.item do
        xml.title article.title
        xml.description article.content
        xml.pubDate article.created_at.to_s
        xml.link article_path article
      end
    end
  end
end
