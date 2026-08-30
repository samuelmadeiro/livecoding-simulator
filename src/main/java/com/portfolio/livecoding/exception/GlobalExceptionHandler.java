package com.portfolio.livecoding.exception;

import jakarta.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.web.ErrorResponse;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(RecursoNaoEncontradoException.class)
    public ResponseEntity<Map<String, Object>> handleNaoEncontrado(RecursoNaoEncontradoException ex) {
        Map<String, Object> corpo = new HashMap<>();
        corpo.put("timestamp", LocalDateTime.now());
        corpo.put("status", HttpStatus.NOT_FOUND.value());
        corpo.put("mensagem", ex.getMessage());
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(corpo);
    }

    @ExceptionHandler(EmailJaCadastradoException.class)
    public ResponseEntity<Map<String, Object>> handleEmailDuplicado(EmailJaCadastradoException ex) {
        Map<String, Object> corpo = new HashMap<>();
        corpo.put("timestamp", LocalDateTime.now());
        corpo.put("status", HttpStatus.CONFLICT.value());
        corpo.put("mensagem", ex.getMessage());
        return ResponseEntity.status(HttpStatus.CONFLICT).body(corpo);
    }

    @ExceptionHandler(BadCredentialsException.class)
    public ResponseEntity<Map<String, Object>> handleCredenciaisInvalidas(BadCredentialsException ex) {
        Map<String, Object> corpo = new HashMap<>();
        corpo.put("timestamp", LocalDateTime.now());
        corpo.put("status", HttpStatus.UNAUTHORIZED.value());
        corpo.put("mensagem", "Email ou senha invalidos.");
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(corpo);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, Object>> handleValidacao(MethodArgumentNotValidException ex) {
        Map<String, String> erros = new HashMap<>();
        ex.getBindingResult().getFieldErrors()
                .forEach(erro -> erros.put(erro.getField(), erro.getDefaultMessage()));

        Map<String, Object> corpo = new HashMap<>();
        corpo.put("timestamp", LocalDateTime.now());
        corpo.put("status", HttpStatus.BAD_REQUEST.value());
        corpo.put("erros", erros);
        return ResponseEntity.badRequest().body(corpo);
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<Map<String, Object>> handleCorpoIlegivel(HttpMessageNotReadableException ex) {
        return ResponseEntity.badRequest()
                .body(corpo(HttpStatus.BAD_REQUEST, "Corpo da requisicao ausente ou em JSON invalido."));
    }

    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<Map<String, Object>> handleAcessoNegado(AccessDeniedException ex) {
        return ResponseEntity.status(HttpStatus.FORBIDDEN)
                .body(corpo(HttpStatus.FORBIDDEN, "Voce nao tem permissao para acessar este recurso."));
    }

    /**
     * Rede de seguranca para qualquer excecao nao mapeada acima.
     * A mensagem original vai para o log, nunca para a resposta: detalhe interno (SQL, caminho de
     * classe, stack) exposto ao cliente e vazamento de informacao.
     *
     * As excecoes proprias do Spring MVC (rota inexistente, verbo nao suportado, enum invalido em
     * query param) implementam ErrorResponse e ja carregam o status certo — sem esse desvio, este
     * handler as rebaixaria todas para 500.
     */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, Object>> handleErroInterno(Exception ex, HttpServletRequest request) {
        if (ex instanceof ErrorResponse erro) {
            HttpStatus status = HttpStatus.valueOf(erro.getStatusCode().value());
            return ResponseEntity.status(status).body(corpo(status, mensagemPara(status)));
        }

        log.error("Erro nao tratado em {} {}", request.getMethod(), request.getRequestURI(), ex);
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(corpo(HttpStatus.INTERNAL_SERVER_ERROR,
                        "Erro interno no servidor. Tente novamente em instantes."));
    }

    /** Texto generico por status: descreve o problema sem repetir detalhe interno da excecao. */
    private String mensagemPara(HttpStatus status) {
        return switch (status) {
            case BAD_REQUEST -> "Requisicao invalida. Confira os parametros enviados.";
            case NOT_FOUND -> "Recurso nao encontrado.";
            case METHOD_NOT_ALLOWED -> "Metodo HTTP nao suportado por esta rota.";
            case UNSUPPORTED_MEDIA_TYPE -> "Content-Type nao suportado. Use application/json.";
            default -> "Nao foi possivel concluir a requisicao.";
        };
    }

    private Map<String, Object> corpo(HttpStatus status, String mensagem) {
        Map<String, Object> corpo = new HashMap<>();
        corpo.put("timestamp", LocalDateTime.now());
        corpo.put("status", status.value());
        corpo.put("mensagem", mensagem);
        return corpo;
    }
}
