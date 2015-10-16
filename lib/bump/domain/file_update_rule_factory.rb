

module Bump

    class FileUpdateRuleFactory

        def self.create file, param, before_version, after_version

            case param
            when String
                return FileUpdateRule.new file, param, before_version, after_version
            when Array
                return param.map { |param| FileUpdateRule.new file, param, before_version, after_version }.flatten
            else
                return FileUpdateRule.new file, nil, before_version, after_version
            end

        end

    end

end
