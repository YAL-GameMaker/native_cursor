{
    "id": "08276c92-80ee-4fd6-82cb-ab4d0f10059a",
    "modelName": "GMExtension",
    "mvc": "1.2",
    "name": "native_cursor_v1_compat",
    "IncludedResources": [
        
    ],
    "androidPermissions": [
        
    ],
    "androidProps": false,
    "androidactivityinject": "",
    "androidclassname": "",
    "androidinject": "",
    "androidmanifestinject": "",
    "androidsourcedir": "",
    "author": "",
    "classname": "",
    "copyToTargets": -1,
    "date": "2022-50-01 02:09:23",
    "description": "",
    "exportToGame": true,
    "extensionName": "",
    "files": [
        {
            "id": "3cf51aa5-60d8-4450-bcbd-cf77c14c75f6",
            "modelName": "GMExtensionFile",
            "mvc": "1.0",
            "ProxyFiles": [
                
            ],
            "constants": [
                
            ],
            "copyToTargets": -1,
            "filename": "native_cursor_compat.gml",
            "final": "",
            "functions": [
                {
                    "id": "3c2c3177-a2ac-793e-604a-07b38d8e66b1",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        
                    ],
                    "externalName": "native_cursor_compat_preinit",
                    "help": "",
                    "hidden": true,
                    "kind": 11,
                    "name": "native_cursor_compat_preinit",
                    "returnType": 2
                },
                {
                    "id": "37bcdfbd-c0ed-bcf2-7edc-09adfb8093b5",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        
                    ],
                    "externalName": "window_set_cursor_normal",
                    "help": "",
                    "hidden": true,
                    "kind": 11,
                    "name": "window_set_cursor_normal",
                    "returnType": 2
                },
                {
                    "id": "3e254635-7f12-5218-deab-49a749b7e4b5",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 2,
                    "args": [
                        2,
                        2
                    ],
                    "externalName": "window_set_cursor_sprite",
                    "help": "window_set_cursor_sprite(sprite, subimg)",
                    "hidden": false,
                    "kind": 2,
                    "name": "window_set_cursor_sprite",
                    "returnType": 2
                },
                {
                    "id": "2cf070a1-2a85-b3c4-162e-e0c7cf34a746",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 6,
                    "args": [
                        2,
                        2,
                        2,
                        2,
                        2,
                        2
                    ],
                    "externalName": "window_set_cursor_sprite_ext",
                    "help": "window_set_cursor_sprite_ext(sprite, subimg, image_xscale, image_yscale, image_blend, image_alpha)",
                    "hidden": false,
                    "kind": 2,
                    "name": "window_set_cursor_sprite_ext",
                    "returnType": 2
                },
                {
                    "id": "2c77b87b-fcd0-859b-1c38-34e9974a2ca9",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 3,
                    "args": [
                        2,
                        2,
                        2
                    ],
                    "externalName": "window_set_cursor_surface",
                    "help": "window_set_cursor_surface(surface, xoffset, yoffset)",
                    "hidden": false,
                    "kind": 2,
                    "name": "window_set_cursor_surface",
                    "returnType": 2
                }
            ],
            "init": "native_cursor_compat_preinit",
            "kind": 2,
            "order": [
                
            ],
            "origname": "",
            "uncompress": false
        }
    ],
    "gradleinject": "",
    "helpfile": "",
    "installdir": "",
    "iosProps": false,
    "iosSystemFrameworkEntries": [
        
    ],
    "iosThirdPartyFrameworkEntries": [
        
    ],
    "iosdelegatename": "",
    "iosplistinject": "",
    "license": "",
    "maccompilerflags": "",
    "maclinkerflags": "",
    "macsourcedir": "",
    "options": null,
    "optionsFile": "options.json",
    "packageID": "",
    "productID": "",
    "sourcedir": "",
    "supportedTargets": -1,
    "tvosProps": false,
    "tvosSystemFrameworkEntries": [
        
    ],
    "tvosThirdPartyFrameworkEntries": [
        
    ],
    "tvosclassname": "",
    "tvosdelegatename": "",
    "tvosmaccompilerflags": "",
    "tvosmaclinkerflags": "",
    "tvosplistinject": "",
    "version": "0.0.1"
}