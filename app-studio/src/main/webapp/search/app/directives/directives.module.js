import {SampleDirective} from "./sample.directive";
import {userSidebar} from "./userSidebar.directive";
import {wordCloud} from "./wordCloud.directive";
import {idEncoder} from "./idEncoder.directive";
import {idDecoder} from "./idDecoder.directive";

export const DirectivesModule = angular.module('as.directives', [])
    // Uncomment .directive line below to add sample directive to the main app module
    // NOTE: This directive is functionally dependant upon common.service.js inclusion in services.module.js
    // .directive('sample', SampleDirective)
    .directive('userSidebar', userSidebar)
    .directive('wordCloud', wordCloud)
    // .directive('idEncoder', idEncoder)
    .directive('idDecoder', idDecoder)
;
