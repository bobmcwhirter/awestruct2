

module Awestruct
  module Handlers
    class InterpolationHandler < BaseHandler

      def initialize(site, delegate)
        super( site, delegate )
      end

      def rendered_content(context)
        content = delegate.rendered_content(context) 

        return nil if content.nil?
        return content unless site.interpolate

        content = content.gsub( /\\/, '\\\\\\\\' )
        content = content.gsub( /\\\\#/, '\\#' )
        content = content.gsub( '@', '\@' )
        content = "%@#{content}@"

        context.instance_eval( content )
      end

    end
  end
end
