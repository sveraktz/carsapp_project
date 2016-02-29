<table>
    <thead>
    <th>Make</th>
    <th>Model</th>
    <th>Year</th>
    </thead>
    <g:each in="${vmyList}" var="vmy">
        <tr>
            <td>${vmy.make}</td>
            <td>${vmy.model}</td>
            <td>${vmy.year}</td>
        </tr>
    </g:each>
</table>