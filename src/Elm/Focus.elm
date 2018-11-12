module Focus exposing (Focus(..), create, get, set, to, update)


type Focus big small
    = Focus
        { get : big -> small
        , update : (small -> small) -> big -> big
        }


create : (big -> small) -> ((small -> small) -> big -> big) -> Focus big small
create g u =
    Focus { get = g, update = u }


get : Focus big small -> big -> small
get (Focus focus) big =
    focus.get big


set : Focus big small -> small -> big -> big
set (Focus focus) small big =
    focus.update (always small) big


update : Focus big small -> (small -> small) -> big -> big
update (Focus focus) f big =
    focus.update f big


to : Focus big medium -> Focus medium small -> Focus big small
to (Focus mid) (Focus small) =
    let
        getter big =
            small.get (mid.get big)

        updater f big =
            mid.update (small.update f) big
    in
    create getter updater
