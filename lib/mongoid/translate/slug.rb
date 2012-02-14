# encoding: utf-8
module Mongoid
  module Translate
    module Slug
      extend ::ActiveSupport::Concern

      # Add scope on slug.
      # Add index on slug.
      #
      included do
        scope :by_slug, lambda {|slug| where('translations.slug' => slug )}
        index 'translations.slug'
      end

      # Return slug.
      # Didn't want to mess with to_param.
      #
      # @example
      #   document.to_slug
      #
      # @return [ String ]
      #
      def to_slug
        locale = languages.include?(I18n.locale) ? I18n.locale : main_language
        translations.where(language: locale).one.slug
      end

      module ClassMethods
        attr_accessor :slugged

        # Defines slug field.
        #
        def slug_field(slug_field)
          self.slugged = slug_field
        end

      end # ClassMethods
    end # Slug
  end # Translate
end # Mongoid
