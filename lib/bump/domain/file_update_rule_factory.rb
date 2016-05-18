module Bump
    # The factory class for the file update rule model
    class FileUpdateRuleFactory
        # Creates the file update rule from the given params.
        #
        # @param [String] file The filename
        # @param [String|Array] param The version update info
        # @param [String] before_version
        # @param [String] after_version
        # @return [Bump::FileUpdateRule, Array<Bump::FileUpdateRule>]
        def self.create(file, param, before_version, after_version)
            case param
            when String
                return FileUpdateRule.new file, param, before_version, after_version
            when Array
                return param.map { |param0| FileUpdateRule.new file, param0, before_version, after_version }.flatten
            else
                return FileUpdateRule.new file, nil, before_version, after_version
            end
        end
    end
end
