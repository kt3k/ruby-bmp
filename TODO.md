# TODO

- use mock library
- gh-pages yardoc

- yaml parse error handling
- no `version` case handling
- no `files` case handling

- refactor: do not exit in application.rb, raise error instead.
- refactor: remove Bump::CLI, move it in bin/bmp

- feat: interactive init, bump --init

# DONE
- test Application
- test CLI
- test Logger
- test Command
- test FileRewriteRule
- test FileRewriteRuleFactory
- test VersionDescriptor
- test VersionDescriptorRepository
- support pre-release version number (of semver)
- support build version number (of semver) - pending
- Generate documentaion
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
