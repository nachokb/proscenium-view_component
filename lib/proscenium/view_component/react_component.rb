# frozen_string_literal: true

module Proscenium::ViewComponent
  # Renders a <div> for use with React components, with data attributes specifying the component
  # path and props.
  #
  # If a content block is given, that content will be rendered inside the component, allowing for a
  # "loading" UI. If no block is given, then a "loading..." text will be rendered. It is intended
  # that the component is mounted to this div, and the loading UI will then be replaced with the
  # component's rendered output.
  class ReactComponent < Base
    self.abstract_class = true

    include Proscenium::ReactComponentable

    def call
      tag.send root_tag, data: data_attributes do
        tag.div content || 'loading...'
      end
    end

    def virtual_path
      @virtual_path ||= begin
        paths = Proscenium::Resolver.resolve(self.class.source_path.sub_ext('.jsx').to_s)
        paths.is_a?(Array) ? paths.find { |x| x.ends_with?('.js') } : paths
      end
    end
  end
end
