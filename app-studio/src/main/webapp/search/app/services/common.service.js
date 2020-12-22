/*ngInject*/
export function CommonService($lightningUrl) {
    return {
        sampleFunct,
    };
    function sampleFunct() {
        //Get value of the q parameter from the URL
        var myQueryVal = $lightningUrl.getUrlParameter('q','*:*');

        return myQueryVal;
    }
}
