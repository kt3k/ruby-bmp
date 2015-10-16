# TODO

- Generate documentaion

- more exception handlings
  - yaml parse error
  - no `version` case
  - no `files` case

- feature
  - Add `this file is auto modified by bmp command` comment
  - `placeholder` field
  - interactive init command
  - label

- test
  - domain - FileRewriteRule
  - domain - FileRewriteRuleFactory
  - domain - VersionDescriptor
  - domain - VersionDescriptorRepository
  - Application
  - CLI
  - Logger
  - Command

# DONE

- Rename file_rewrite_rule to file_update_rule
- Rename version_descriptor to bump_info
- Refactor application
- travis - done
- coveralls - done
- introduce simplecov - done
- git tag when -f - done
- show command before execution - done
- write tests
  - Version - done
  - VersionFactory - done
- separate classes into separate files - done
- decent console log - done
  - git command outputs
- bump description - done
- introduce slop - done
- introduce commander - no
