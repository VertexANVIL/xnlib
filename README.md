## XTended Nix Library

This is an extended version of the NixOS library shared by a bunch of repositories that Arctarus hosts. It adds the following new functions:

| Name | Purpose |
| :-- | :-- |
| `mapFilterAttrs` | Maps and filters an attribute set at the same time |
| `genAttrs'` | Generates an attribute set by mapping a function over a list of values |
| `attrCount` | Counts the number of attributes in a set |
| `defaultAttrs` | Defaults members of the attribute set to the specified value if they are null |
| `defaultSetAttrs` | Given a list of attribute sets, merges the keys specified by "names" from "defaults" into them if they do not exist |
| `imapAttrsToList` | Maps attrs to list with an extra i iteration parameter |
| `recursiveMerge` | Recursively merges attribute sets *and* lists |
| `recursiveMergeAttrsWith` | Recursively merges these attribute sets |
| `recursiveMergeAttrsWithNames` | Recursively merges only these keys of these attribute sets |
| `pathsToImportedAttrs` | Converts a list to file paths to attribute set that has the filenames stripped of nix extension as keys and imported content of the file as value |
| `recImportFiles` | Recursively imports Nix files from a directory tree |
| `recImportDirs` | Recursively imports directories |
| `nixFilesIn` | Converts nix files in directory to name/value pairs |
| `filterListNonEmpty` | Filters out empty strings and null objects from a list |
