# frozen_string_literal: true

require "active_support/concern"

module Decidim
  # This concern contains the logic related to scopes included by resources.
  module ScopableResource
    extend ActiveSupport::Concern

    included do
      include Scopable

      belongs_to :scope,
                 foreign_key: "decidim_scope_id",
                 class_name: "Decidim::Scope",
                 optional: true

      delegate :scopes_enabled, to: :component

      validate :scope_belongs_to_component
    end

    # # Whether the resource has subscopes or not.
    # #
    # # Returns a boolean.
    # def has_subscopes?
    #   scopes_enabled && subscopes.any?
    # end
  end
end
