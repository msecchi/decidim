# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module Budgets
    # Shared behaviour for controllers that need the current order to be present.
    module NeedsCurrentOrder
      extend ActiveSupport::Concern

      included do
        helper_method :show_votes?, :finished?, :current_order, :can_have_order?, :checked_out?, :project_chosen?, :project_accepted?

        # The current order created by the user.
        #
        # Returns an Order.
        def current_order
          @current_order ||= Order.includes(:projects).find_or_initialize_by(user: current_user, component: current_component)
        end

        def current_order=(order)
          @current_order = order
        end

        def persisted_current_order
          current_order if current_order&.persisted?
        end

        def can_have_order?
          current_user.present? &&
            current_settings.votes_enabled? &&
            current_participatory_space.can_participate?(current_user) &&
            allowed_to?(:create, :order, parent_component_context: parent_component_context)
        end

        delegate :show_votes?, to: :current_settings
        delegate :checked_out?, to: :current_order, allow_nil: true

        def finished?
          !current_settings.votes_enabled? && show_votes?
        end

        def project_chosen?(project)
          current_order&.projects&.include?(project)
        end
      end
    end
  end
end
