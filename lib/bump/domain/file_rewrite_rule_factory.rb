

module Bump

    class FileRewriteRuleFactory

        def self.create file, param, before_version, after_version

            case param
            when String
                return FileRewriteRule.new file, param, before_version, after_version
            when Array
                return param.map { |param| FileRewriteRule.new file, param, before_version, after_version }.flatten
            else
                return FileRewriteRule.new file, nil, before_version, after_version
            end

        end

    end

end
