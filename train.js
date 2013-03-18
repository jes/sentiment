var next_page = {};
var tweets = [];
var current_tweet;

function update_tweet() {
    current_tweet = tweets.shift();
    $('#tweet').html(current_tweet.text);
}

function next_tweet() {
    if (tweets == undefined || tweets.length == 0) {
        var query = $('#query').val();

        var params = next_page[query];
        if (params == undefined) {
            params = '?q=' + query;
        }

        console.log("http://search.twitter.com/search.json" + params);
        $.getJSON("http://search.twitter.com/search.json" + params + "&callback=?",
            function (r) {
                next_page[query] = r.next_page;
                tweets = r.results;
                console.log(r);
                update_tweet();
            }
        );
    } else {
        update_tweet();
    }
}

function classify(type) {
    $.ajax({
        url: 'train.cgi',
        data: { words: current_tweet.text, type: type },
    });
    next_tweet();
}

function freshen() {
    tweets = [];
    next_tweet();
}

$('#query').keyup(function(e) {
    if (e.keyCode == 13) {
        freshen();
    }

    return false;
});

next_tweet();
