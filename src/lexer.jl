import Automa
import Automa.RegExp: @re_str
const re = Automa.RegExp

sp = re" "
tab = re"\t"
lf = re"\n"
num = re.cat(re.rep1(re"[ \t]"), "\n")
label = num

actions = Automa.compile(
    re.cat("  ", num)       => :(num(:push, 2)),
    re" \n "                => :(emit(:dup)),
    re.cat(" \t ", num)     => :(num(:copy, 3)),
    re" \n\t"               => :(emit(:swap)),
    re" \n\n"               => :(emit(:discard)),
    re.cat(" \t\n", num)    => :(num(:slide, 3)),
    re"\t   "               => :(emit(:add)),
    re"\t  \t"              => :(emit(:sub)),
    re"\t  \n"              => :(emit(:mul)),
    re"\t \t "              => :(emit(:div)),
    re"\t \t\t"             => :(emit(:mod)),
    re"\t\t "               => :(emit(:heap_write)),
    re"\t\t\t"              => :(emit(:heap_read)),
    re.cat("\n  ", label)   => :(label(:label, 3)),
    re.cat("\n \t", label)  => :(label(:call, 3)),
    re.cat("\n \n", label)  => :(label(:jump, 3)),
    re.cat("\n\t ", label)  => :(label(:jump_zero, 3)),
    re.cat("\n\t\t", label) => :(label(:jump_nega, 3)),
    re"\n\t\n"              => :(emit(:return)),
    re"\n\n\n"              => :(emit(:exit)),
    re"\t\n  "              => :(emit(:char_out)),
    re"\t\n \t"             => :(emit(:num_out)),
    re"\t\n\t "             => :(emit(:char_in)),
    re"\t\n\t\t"            => :(emit(:num_in))
)

context = Automa.CodeGenContext()

@eval function tokenize(data)
    $(Automa.generate_init_code(context, actions))
    p_end = p_eof = sizeof(data)
    tokens = Tuple{Symbol,String}[]

    emit(kind) = push!(tokens, (kind, data[ts:te]))

    # name, l: symbol of operation, length of matched string
    function num(name, l)
        push!(tokens, (name, data[ts:ts+l-1]))
        str = data[ts+l:te-1]
        str = replace(str, r"\A\t" => "-")
        str = replace(str, r"\A " => "+")
        str = replace(str, r" " => "0")
        str = replace(str, r"\t" => "1")
        push!(tokens, (:num, string(parse(Int, str, base=2))))
    end

    function label(name, l)
        push!(tokens, (name, data[ts:ts+l-1]))
        push!(tokens, (:label_name, data[ts+l:te-1]))
    end

    while p ≤ p_eof && cs > 0
        $(Automa.generate_exec_code(context, actions))
    end
    if cs < 0
        error("failed to tokenize")
    end
    return tokens
end
