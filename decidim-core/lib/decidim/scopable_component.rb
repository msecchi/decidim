# frozen_string_literal: true

require "active_support/concern"

module Decidim
  # This concern contains the logic related to scopes included by components.
  module ScopableComponent
    extend ActiveSupport::Concern

    included do
      include Scopable

      validate :scope_belongs_to_participatory_space
    end

    # Public: Returns the component Scope
    # overrides the method from Scopable
    def scope
      return participatory_space.scope unless scopes_enabled

      participatory_space.scopes.find_by(id: settings.scope_id)
    end

    # overrides the method from Scopable
    #
    # Returns a boolean.
    def scopes_enabled
      settings.try(:scopes_enabled)
    end

    # Whether the component or participatory_space has subscopes or not.
    #
    # Returns a boolean.
    def has_subscopes?
      scopes_enabled || participatory_space.scopes_enabled && subscopes.any?
    end
  end
end
