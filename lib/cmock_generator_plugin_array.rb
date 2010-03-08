class CMockGeneratorPluginArray

  attr_reader :priority
  attr_accessor :config, :utils, :unity_helper, :ordered
  def initialize(config, utils)
    @config       = config
    @ptr_handling = @config.when_ptr
    @ordered      = @config.enforce_strict_ordering
    @utils        = utils
    @unity_helper = @utils.helpers[:unity_helper]
    @priority     = 8
  end

  def instance_typedefs(function)
    function[:args].inject("") do |all, arg|
      (arg[:ptr?]) ? all + "  int Expected_#{arg[:name]}_Depth;\n" : all
    end
  end

  def mock_function_declarations(function)
    return nil unless function[:contains_ptr?]
    if (function[:args_string] == "void")
      if (function[:return][:void?])
        return "void #{function[:name]}_ExpectWithArray(void);\n"
      else
        return "void #{function[:name]}_ExpectWithArrayAndReturn(#{function[:return][:str]});\n"
      end
    else
      args_string = function[:args].map{|m| m[:ptr?] ? "#{m[:type]} #{m[:name]}, int #{m[:name]}_Depth" : "#{m[:type]} #{m[:name]}"}.join(', ')
      if (function[:return][:void?])
        return "void #{function[:name]}_ExpectWithArray(#{args_string});\n"
      else
        return "void #{function[:name]}_ExpectWithArrayAndReturn(#{args_string}, #{function[:return][:str]});\n"
      end
    end
  end

  def mock_interfaces(function)
    return nil unless function[:contains_ptr?]
    lines = []
    func_name = function[:name]
    args_string = function[:args].map{|m| m[:ptr?] ? "#{m[:type]} #{m[:name]}, int #{m[:name]}_Depth" : "#{m[:type]} #{m[:name]}"}.join(', ')
    call_string = function[:args].map{|m| m[:ptr?] ? "#{m[:name]}, #{m[:name]}_Depth" : m[:name]}.join(', ')
    if (function[:return][:void?])
      lines << "void #{func_name}_ExpectWithArray(#{args_string})\n"
    else
      lines << "void #{func_name}_ExpectWithArrayAndReturn(#{args_string}, #{function[:return][:str]})\n"
    end
    lines << "{\n"
    lines << @utils.code_add_base_expectation(func_name)
    lines << "  CMockExpectParameters_#{func_name}(cmock_call_instance, #{call_string});\n"
    lines << "  cmock_call_instance->ReturnVal = cmock_to_return;\n" unless (function[:return][:void?])
    lines << "}\n\n"
  end

end