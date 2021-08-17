let missionData = null

window.addEventListener('message', function(e) {
    missionData = e.data.mission
    if(e.data.message == 'introText') {
        $('.container').css('display', 'flex')
        InsertData()
    } else if (e.data.message == 'closeui') {
        $('.container').css('display', 'none')
        $('#story-text').empty()
    } else if (e.data.message == 'confirm') {
        ConfirmText()
    }
})

document.onkeyup = function(data) {
    if (data.which == 27) {
        $.post('https://siir_pedMissions/close', JSON.stringify({}));
    }
};

function InsertData() {
    document.onkeyup = function (key) {
        if (key.which == 69) {
            return false;
        }
    }
    let intro = new Typed('#story-text', {
        strings: [missionData.introText + "<div class='continue'>&nbsp;~&nbsp;<span>[E]</span> Continue</div>"],
        showCursor: false,
        loop: false,
        onComplete: function(self) {
            document.onkeyup = function(data) {
                if (data.which == 69) {
                    $('#story-text').empty()
                    ConfirmText()
                }
            }
        }
    })
}

function ConfirmText() {
    document.onkeyup = function (key) {
        if (key.which == 69) {
            return false;
        }
    }
    let done = new Typed('#story-text', {
        strings: [missionData.confirmText + "<div class='continue'>&nbsp;~&nbsp;<span>[E]</span> Continue</div>"],
        showCursor: false,
        loop: false,
        onComplete: function(self) {
            document.onkeyup = function(data) {
                if (data.which == 69) {
                    $.post('https://siir_pedMissions/confirm', JSON.stringify({}));
                }
            }
        }
    })
}