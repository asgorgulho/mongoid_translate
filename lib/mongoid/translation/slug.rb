# encoding: utf-8
module Mongoid
  module Translation
    module Slug
      extend ::ActiveSupport::Concern

      # Add slug field.
      # Add callback for slug creation.
      #
      included do
        field :slug, type: String
        after_validation :set_slug
      end

      # Slug creation.
      #
      # @return [ Object ]
      #
      def set_slug
        if self.slug.blank? && slugged_field.present?
          if translation_parent_class.send(:by_slug, slugged).one
            self.slug = slugged_with_token
          else
            self.slug = slugged
          end
        end
      end

      private

      def slugged_field
        @slugged_field ||= self.send(translation_parent_class.slugged)
      end

      def slugged
        @slugged ||= slugged_field.parameterize.blank? ? slugged_field : slugged_field.parameterize
      end

      def slugged_with_token
        @slugged_with_token ||= [slugged, generate_token].join('-')
      end

      def translation_parent_class
        self.class.to_s.sub('Translation::', '').constantize
      end

      def translation_parent
        self.send(self.class.to_s.sub(/^.*::/, '').underscore)
      end

      def generate_token
        SecureRandom.base64(4).tr('+/=', '-_ ').strip.delete("\n")
      end
      end
  end # Translation
end # Mongoid
