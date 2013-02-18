# coding: utf-8
module DingIT
  module MarkdownContent
    extend ActiveSupport::Concern

    included do
      before_save :markdown_content
      scope :without_content, without(:content)
    end

    private
      def markdown_content
        self.content_html = MarkdownTopicConverter.format(self.content) if self.content_changed?
      end
  end
end
