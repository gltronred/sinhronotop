xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.Workbook({
  'xmlns'      => "urn:schemas-microsoft-com:office:spreadsheet",
  'xmlns:o'    => "urn:schemas-microsoft-com:office:office",
  'xmlns:x'    => "urn:schemas-microsoft-com:office:excel",
  'xmlns:html' => "http://www.w3.org/TR/REC-html40",
  'xmlns:ss'   => "urn:schemas-microsoft-com:office:spreadsheet"
}) do

  xml.Worksheet 'ss:Name' => @context_array.join(' >> ') do
    xml.Table do

      # Header
      xml.Row do
        xml.Cell { xml.Data 'Город', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Страна', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Статус заявки', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Дата', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Время', 'ss:Type' => 'String' } if @game.tournament.time_required
        xml.Cell { xml.Data 'Ведущий', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Email ведущего', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Доп. Email ведущего', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Представитель', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Email представителя', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Команд', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'IPs', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Отчет', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Дополнительная информация', 'ss:Type' => 'String' }
      end

      # Rows
      for event in @events
        xml.Row do
          xml.Cell { xml.Data event.city.name, 'ss:Type' => 'String' }
          xml.Cell { xml.Data event.city.country, 'ss:Type' => 'String' }
          xml.Cell { xml.Data event.event_status.name, 'ss:Type' => 'String' }
          xml.Cell { xml.Data event.date.loc, 'ss:Type' => 'String' }
          xml.Cell { xml.Data event.game_time, 'ss:Type' => 'String' }  if @game.tournament.time_required
          xml.Cell { xml.Data event.get_moderator_name, 'ss:Type' => 'String' }
          xml.Cell { xml.Data event.get_moderator_email, 'ss:Type' => 'String' }
          xml.Cell { xml.Data event.get_moderator_email2, 'ss:Type' => 'String' }          
          xml.Cell { xml.Data event.user.name, 'ss:Type' => 'String' }
          xml.Cell { xml.Data event.user.email, 'ss:Type' => 'String' }
          xml.Cell { xml.Data event.num_teams, 'ss:Type' => 'String' }
          xml.Cell { xml.Data event.ips, 'ss:Type' => 'String' }
          xml.Cell { xml.Data event.get_report_status, 'ss:Type' => 'String' }
          xml.Cell { xml.Data event.more_info, 'ss:Type' => 'String' }
        end
      end

    end
  end
end
