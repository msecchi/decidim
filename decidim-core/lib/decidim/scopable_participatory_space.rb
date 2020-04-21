# frozen_string_literal: true

require "active_support/concern"

module Decidim
  # Specific methods for scoped participatory spaces.
  module ScopableParticipatorySpace
    extend ActiveSupport::Concern

    included do
      include Scopable

      belongs_to :scope,
                 foreign_key: "decidim_scope_id",
                 class_name: "Decidim::Scope",
                 optional: true

      delegate :scopes, to: :organization

      validate :scope_belongs_to_organization
    end

    # # Whether the participatory space has subscopes or not.
    # #
    # # Returns a boolean.
    # def has_subscopes?
    #   scopes_enabled && subscopes.any?
    # end
  end
end
