function vm_execute!(io, ws)
    return_to = Vector{Int}()
    pc = 1
    while pc < length(ws.insns) + 1
        insn = ws.insns[pc][1]

        if insn == :push
            pc += 1
            arg = parse(Int, ws.insns[pc][2])
            push!(ws.stack, arg)
        elseif insn == :dup
            push!(ws.stack, ws.stack[end])
        elseif insn == :copy
            pc += 1
            arg = parse(Int, ws.insns[pc][2])
            push!(ws.stack, ws.stack[end - arg])
        elseif insn == :swap
            ws.stack[end], ws.stack[end-1] = ws.stack[end-1], ws.stack[end]
        elseif insn == :discard
            pop!(ws.stack)
        elseif insn == :slide
            pc += 1
            arg = parse(Int, ws.insns[pc][2])
            x = pop!(ws.stack)
            for i in 1:arg
                pop!(ws.stack)
            end
            push!(ws.stack, x)
        elseif insn == :add
            y, x = pop!(ws.stack), pop!(ws.stack)
            push!(ws.stack, x + y)
        elseif insn == :sub
            y, x = pop!(ws.stack), pop!(ws.stack)
            push!(ws.stack, x - y)
        elseif insn == :mul
            y, x = pop!(ws.stack), pop!(ws.stack)
            push!(ws.stack, x * y)
        elseif insn == :div
            y, x = pop!(ws.stack), pop!(ws.stack)
            push!(ws.stack, div(x, y))
        elseif insn == :mod
            y, x = pop!(ws.stack), pop!(ws.stack)
            push!(ws.stack, mod(x, y))
        elseif insn == :heap_write
            value, address = pop!(ws.stack), pop!(ws.stack)
            ws.heap[address] = value
        elseif insn == :heap_read
            address = pop!(ws.stack)
            value = ws.heap[address]
            push!(ws.stack, value)
        elseif insn == :label
            # do nothing
        elseif insn == :jump
            pc += 1
            arg = ws.insns[pc][2]
            pc = jump_to(ws, arg)
        elseif insn == :jump_zero
            pc += 1
            arg = ws.insns[pc][2]
            if iszero(pop!(ws.stack))
                pc = jump_to(ws, arg)
            end
        elseif insn == :jump_nega
            pc += 1
            arg = ws.insns[pc][2]
            if pop!(ws.stack) < 0
                pc = jump_to(ws, arg)
            end
        elseif insn == :call
            pc += 1
            arg = ws.insns[pc][2]
            push!(return_to, pc)
            pc = jump_to(ws, arg)
        elseif insn == :return
            pc = pop!(return_to)
        elseif insn == :exit
            return

        elseif insn == :char_out
            print(io, Char(pop!(ws.stack)))
        elseif insn == :num_out
            print(io, pop!(ws.stack))
        elseif insn == :char_in
            address = pop!(ws.stack)
            ws.heap[address] = read(stdin, Char)
        elseif insn == :num_in
            address = pop!(ws.stack)
            ws.heap[address] = parse(Int, readline())
        end

        pc += 1
    end
    error()
end

vm_execute!(ws) = vm_execute!(stdout, ws)

function find_labels(insns)
    labels = Dict()
    afterlabel = false
    for (i, (key, val)) in enumerate(insns)
        if key == :label
            afterlabel = true
        elseif afterlabel
            labels[val] = i
            afterlabel = false
        else
            afterlabel = false
        end
    end
    labels
end

function jump_to(ws, name)
    ws.labels[name]
end

