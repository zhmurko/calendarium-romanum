module CalendariumRomanum

  module Util

    # Abstract superclass for date enumerators.
    class DateEnumerator
      include Enumerable

      def each
        d = @start
        begin
          yield d
          d = d.succ
        end until enumeration_over? d
      end

      def enumeration_over?(date)
        @start.send(@prop) != date.send(@prop)
      end

      alias_method :each_day, :each
    end

    # enumerates days of a year
    class Year < DateEnumerator
      def initialize(year)
        @start = Date.new year, 1, 1
        @prop = :year
      end
    end

    # enumerates days of a month
    class Month < DateEnumerator
      def initialize(year, month)
        @start = Date.new year, month, 1
        @prop = :month
      end
    end

    class DateParser
      attr_reader :date_range
      def initialize(date_str)
        if (date_str =~ /((\d{4})(\/|-)?(\d{0,2})(\/|-)?(\d{0,2}))\z/) # Accepts YYYY-MM-DD, YYYY/MM/DD where both day and month are optional
          year = $2.to_i
          month = $4.to_i 
          day = $6.to_i
          if ((day == 0) && (month == 0)) # Only year is given
            @date_range = Year.new(year)
          elsif (day == 0) # Year and month are given
            @date_range = Month.new(year, month)
          else
            @date_range = Date.new(year, month, day)..Date.new(year, month, day)
          end
        else
          raise ArgumentError, "Unparseable date"
        end
      end
    end


  end
end
