# frozen_string_literal: true

module Feedjira
  module Parser
    module Oasis
      class MrssEntry
        include SAXMachine
        include FeedEntryUtilities

        element :guid, as: :entry_id
        element :'dc:identifier', as: :entry_id
        element :title
        element :link, as: :url
        element :pubDate, as: :pub_date
        element :pubdate, as: :pub_date
        element :'dc:date', as: :pub_date
        element :'dc:Date', as: :pub_date
        element :'dcterms:created', as: :pub_date
        element :issued, as: :pub_date
        element 'media:thumbnail', value: :url, as: :thumbnail_url
        element :description, as: :summary
        element 'media:description', as: :summary
        element 'content:encoded', as: :summary

        def title
          sanitize(@title)
        end

        def summary
          sanitize(@summary)
        end

        def url
          ensure_scheme_present(@url)
        end

        def thumbnail_url
          ensure_scheme_present(@thumbnail_url)
        end

        private

        def sanitize(unsafe_html)
          doc = Loofah.fragment(unsafe_html)
          doc.text.strip.squish
        end

        def ensure_scheme_present(link)
          scheme_regex = %r{^https?://}i
          scheme_regex.match?(link) ? link : "http://#{link}"
        end
      end
    end
  end
end
