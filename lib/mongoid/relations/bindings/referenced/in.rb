# encoding: utf-8
module Mongoid # :nodoc:
  module Relations #:nodoc:
    module Bindings #:nodoc:
      module Referenced #:nodoc:
        class In < Binding

          # Binds the base object to the inverse of the relation. This is so we
          # are referenced to the actual objects themselves and dont hit the
          # database twice when setting the relations up.
          #
          # This sets the foreign key on the child and the object on the
          # parent.
          #
          # Example:
          #
          # <tt>game.person.bind</tt>
          def bind
            if bindable?(base)
              inverse = metadata.inverse(target)
              base.metadata = target.reflect_on_association(inverse)
              base.send(metadata.foreign_key_setter, target.id)
              if base.referenced_many?
                target.send(inverse).push(base)
              else
                target.send(metadata.inverse_setter(target), base)
              end
            end
          end

          # Unbinds the base object to the inverse of the relation. This occurs
          # when setting a side of the relation to nil.
          #
          # Example:
          #
          # <tt>game.person.unbind</tt>
          def unbind
            if unbindable?
              base.send(metadata.foreign_key_setter, nil)
              target.send(metadata.inverse_setter(target), nil)
            end
          end

          def unbindable?
            # base = game
            # target = person
            # Can I set person.game to nil?
            !target.send(metadata.inverse(target)).blank?
          end
        end
      end
    end
  end
end