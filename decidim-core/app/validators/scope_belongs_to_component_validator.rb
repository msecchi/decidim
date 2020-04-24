# frozen_string_literal: true

# This validator ensures the scope is a scope of a component scope,
class ScopeBelongsToComponentValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless record.component

    record.errors.add(attribute, :invalid) unless record.component.scopes.where(id: value).exists?
  end
end
